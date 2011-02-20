//
//  PPPlayingTrackView.m
//  PPClient
//
//  Created by Robert Höglund on 2/18/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import "PPPlayingTrackView.h"
#import "PPSpotifyTrack.h"
#import "PPPlayingTrack.h"

@interface PPPlayingTrackView()
@property (nonatomic, retain) PPPlayingTrack *playingTrack;
@end

@implementation PPPlayingTrackView

@synthesize title;
@synthesize arrowSize;
@synthesize playingTrack;
@synthesize imageMargin;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    [title release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(0, 0), 2.0);	
	
    CGFloat titleHeight = 26.0f;
    
	CGRect viewBounds = self.bounds;
	viewBounds.size.height = titleHeight;
	
	CGFloat halfWidth = viewBounds.size.width / 2.0f;
	CGFloat bottom = titleHeight + 4.0f;
	CGFloat lineRGB = 217.0f/255.0f;
	CGFloat margin = 0.0f;
	
    
	// construct the arrow line at the bottom
	CGPoint points[5];
	points[0] = CGPointMake (margin, bottom);
	points[1] = CGPointMake (halfWidth - arrowSize, bottom);
	points[2] = CGPointMake (halfWidth, bottom + arrowSize);	
	points[3] = CGPointMake (halfWidth + arrowSize, bottom);
	points[4] = CGPointMake(viewBounds.size.width - margin, bottom);
	
    // This is what we are filling
    UIColor *fillColor = [UIColor colorWithWhite:0 alpha:0.8];
	CGContextSetFillColorWithColor(context, fillColor.CGColor);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, margin, margin);
	CGContextAddLines(context, points, 5);
	CGContextAddLineToPoint(context, viewBounds.size.width - margin, margin);
	CGContextAddLineToPoint(context, margin, margin);
	CGContextClosePath(context);
	CGContextFillPath(context);

	// and this is the line at the bottom
	CGContextSetRGBStrokeColor(context, lineRGB, lineRGB, lineRGB, 1.0);
	CGContextAddLines(context, points, 5);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
    
    [[UIColor colorWithWhite:1.0 alpha:0.8f] set];
    [self.title drawAtPoint:CGPointMake(5.0f, 5.0f) withFont:[UIFont boldSystemFontOfSize:14.0]];
    
    UIImage *albumCover = self.playingTrack.albumCover;

    if (albumCover) {
        CGFloat imageSize = self.bounds.size.height - bottom - 2 * imageMargin;
        [albumCover drawInRect:CGRectMake(imageMargin, bottom + imageMargin, imageSize, imageSize)];
    }
    
    UIColor *titleColor = [UIColor blackColor];
    [titleColor set];
    UIFont *titleFont = [UIFont systemFontOfSize:15.0f];
    CGFloat textLeft = self.bounds.size.height - bottom + 5.0;
    CGFloat textTop = bottom + 10.0f;
    CGSize titleSize = 
    [self.playingTrack.track.title drawAtPoint:CGPointMake(textLeft, textTop)
                                      forWidth:self.bounds.size.width - textLeft
                                      withFont:titleFont 
                                   minFontSize:12.0
                                actualFontSize:NULL
                                 lineBreakMode:UILineBreakModeTailTruncation 
                            baselineAdjustment:UIBaselineAdjustmentNone];    
    
    textTop += titleSize.height + 5.0;
    CGSize artistSize =
    [self.playingTrack.track.artistName drawAtPoint:CGPointMake(textLeft, textTop)
                                           forWidth:self.bounds.size.width - textLeft
                                           withFont:titleFont 
                                        minFontSize:12.0
                                     actualFontSize:NULL
                                      lineBreakMode:UILineBreakModeTailTruncation 
                                 baselineAdjustment:UIBaselineAdjustmentNone];    

    textTop += artistSize.height + 5.0f;
    [self.playingTrack.track.albumName drawAtPoint:CGPointMake(textLeft, textTop)
                                          forWidth:self.bounds.size.width - textLeft
                                          withFont:titleFont 
                                       minFontSize:12.0
                                    actualFontSize:NULL
                                     lineBreakMode:UILineBreakModeTailTruncation 
                                baselineAdjustment:UIBaselineAdjustmentNone];    

    
}

- (void)displaySpotifyTrack:(PPPlayingTrack *)track {
    [self.playingTrack removeObserver:self forKeyPath:@"albumCover"];
    self.playingTrack = track;
    [self.playingTrack addObserver:self forKeyPath:@"albumCover" 
                           options:NSKeyValueObservingOptionNew context:nil];
    [self setNeedsDisplay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
    NSLog(@"albumCover updated in %@", self.title);
    [self setNeedsDisplay];
}

@end
