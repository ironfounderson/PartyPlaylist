// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Track.m instead.

#import "_Track.h"

@implementation TrackID
@end

@implementation _Track

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Track" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Track";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Track" inManagedObjectContext:moc_];
}

- (TrackID*)objectID {
	return (TrackID*)[super objectID];
}




@dynamic title;






@dynamic artistName;






@dynamic favorite;



- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}





@dynamic link;






@dynamic albumName;










@end
