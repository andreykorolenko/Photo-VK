// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.h instead.

#import <CoreData/CoreData.h>
#import "Album.h"

extern const struct PhotoRelationships {
	__unsafe_unretained NSString *album;
} PhotoRelationships;

@class Album;

@interface PhotoID : AlbumID {}
@end

@interface _Photo : Album {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoID* objectID;

@property (nonatomic, strong) Album *album;

//- (BOOL)validateAlbum:(id*)value_ error:(NSError**)error_;

+ (NSArray*)fetchPhotosFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ ;
+ (NSArray*)fetchPhotosFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_;

@end

@interface _Photo (CoreDataGeneratedPrimitiveAccessors)

- (Album*)primitiveAlbum;
- (void)setPrimitiveAlbum:(Album*)value;

@end
