// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.h instead.

#import <CoreData/CoreData.h>

extern const struct AlbumAttributes {
	__unsafe_unretained NSString *countPhoto;
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *imageURL;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *uid;
} AlbumAttributes;

extern const struct AlbumRelationships {
	__unsafe_unretained NSString *albumManager;
	__unsafe_unretained NSString *photos;
} AlbumRelationships;

@class AlbumManager;
@class Photo;

@interface AlbumID : NSManagedObjectID {}
@end

@interface _Album : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AlbumID* objectID;

@property (nonatomic, strong) NSNumber* countPhoto;

@property (atomic) int16_t countPhotoValue;
- (int16_t)countPhotoValue;
- (void)setCountPhotoValue:(int16_t)value_;

//- (BOOL)validateCountPhoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* imageURL;

//- (BOOL)validateImageURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* uid;

@property (atomic) int64_t uidValue;
- (int64_t)uidValue;
- (void)setUidValue:(int64_t)value_;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) AlbumManager *albumManager;

//- (BOOL)validateAlbumManager:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *photos;

- (NSMutableOrderedSet*)photosSet;

+ (NSArray*)fetchAlbumsFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ ;
+ (NSArray*)fetchAlbumsFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_;

@end

@interface _Album (PhotosCoreDataGeneratedAccessors)
- (void)addPhotos:(NSOrderedSet*)value_;
- (void)removePhotos:(NSOrderedSet*)value_;
- (void)addPhotosObject:(Photo*)value_;
- (void)removePhotosObject:(Photo*)value_;

- (void)insertObject:(Photo*)value inPhotosAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx;
- (void)insertPhotos:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(Photo*)value;
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray *)values;

@end

@interface _Album (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCountPhoto;
- (void)setPrimitiveCountPhoto:(NSNumber*)value;

- (int16_t)primitiveCountPhotoValue;
- (void)setPrimitiveCountPhotoValue:(int16_t)value_;

- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;

- (NSString*)primitiveImageURL;
- (void)setPrimitiveImageURL:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveUid;
- (void)setPrimitiveUid:(NSNumber*)value;

- (int64_t)primitiveUidValue;
- (void)setPrimitiveUidValue:(int64_t)value_;

- (AlbumManager*)primitiveAlbumManager;
- (void)setPrimitiveAlbumManager:(AlbumManager*)value;

- (NSMutableOrderedSet*)primitivePhotos;
- (void)setPrimitivePhotos:(NSMutableOrderedSet*)value;

@end
