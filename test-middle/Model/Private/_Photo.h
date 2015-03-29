// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.h instead.

#import <CoreData/CoreData.h>

extern const struct PhotoAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *haveMap;
	__unsafe_unretained NSString *isUserLike;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *likes;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *originalSizeURL;
	__unsafe_unretained NSString *smallSizeURL;
	__unsafe_unretained NSString *uid;
} PhotoAttributes;

extern const struct PhotoRelationships {
	__unsafe_unretained NSString *album;
} PhotoRelationships;

@class Album;

@interface PhotoID : NSManagedObjectID {}
@end

@interface _Photo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoID* objectID;

@property (nonatomic, strong) NSDate* date;

//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* haveMap;

@property (atomic) BOOL haveMapValue;
- (BOOL)haveMapValue;
- (void)setHaveMapValue:(BOOL)value_;

//- (BOOL)validateHaveMap:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isUserLike;

@property (atomic) BOOL isUserLikeValue;
- (BOOL)isUserLikeValue;
- (void)setIsUserLikeValue:(BOOL)value_;

//- (BOOL)validateIsUserLike:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* likes;

@property (atomic) int16_t likesValue;
- (int16_t)likesValue;
- (void)setLikesValue:(int16_t)value_;

//- (BOOL)validateLikes:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* originalSizeURL;

//- (BOOL)validateOriginalSizeURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* smallSizeURL;

//- (BOOL)validateSmallSizeURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* uid;

@property (atomic) int64_t uidValue;
- (int64_t)uidValue;
- (void)setUidValue:(int64_t)value_;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Album *album;

//- (BOOL)validateAlbum:(id*)value_ error:(NSError**)error_;

+ (NSArray*)fetchPhotosFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ ;
+ (NSArray*)fetchPhotosFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_;

@end

@interface _Photo (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;

- (NSNumber*)primitiveHaveMap;
- (void)setPrimitiveHaveMap:(NSNumber*)value;

- (BOOL)primitiveHaveMapValue;
- (void)setPrimitiveHaveMapValue:(BOOL)value_;

- (NSNumber*)primitiveIsUserLike;
- (void)setPrimitiveIsUserLike:(NSNumber*)value;

- (BOOL)primitiveIsUserLikeValue;
- (void)setPrimitiveIsUserLikeValue:(BOOL)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLikes;
- (void)setPrimitiveLikes:(NSNumber*)value;

- (int16_t)primitiveLikesValue;
- (void)setPrimitiveLikesValue:(int16_t)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSString*)primitiveOriginalSizeURL;
- (void)setPrimitiveOriginalSizeURL:(NSString*)value;

- (NSString*)primitiveSmallSizeURL;
- (void)setPrimitiveSmallSizeURL:(NSString*)value;

- (NSNumber*)primitiveUid;
- (void)setPrimitiveUid:(NSNumber*)value;

- (int64_t)primitiveUidValue;
- (void)setPrimitiveUidValue:(int64_t)value_;

- (Album*)primitiveAlbum;
- (void)setPrimitiveAlbum:(Album*)value;

@end
