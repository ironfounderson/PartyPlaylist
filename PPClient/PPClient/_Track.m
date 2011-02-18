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






@dynamic link;






@dynamic albumName;










@end
