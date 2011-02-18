// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Track.h instead.

#import <CoreData/CoreData.h>








@interface TrackID : NSManagedObjectID {}
@end

@interface _Track : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TrackID*)objectID;



@property (nonatomic, retain) NSString *title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *artistName;

//- (BOOL)validateArtistName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *link;

//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *albumName;

//- (BOOL)validateAlbumName:(id*)value_ error:(NSError**)error_;





@end

@interface _Track (CoreDataGeneratedAccessors)

@end

@interface _Track (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;


- (NSString*)primitiveArtistName;
- (void)setPrimitiveArtistName:(NSString*)value;


- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;


- (NSString*)primitiveAlbumName;
- (void)setPrimitiveAlbumName:(NSString*)value;



@end
