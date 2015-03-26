// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumList.h instead.

#import <CoreData/CoreData.h>

extern const struct AlbumListAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *uid;
} AlbumListAttributes;

@interface AlbumListID : NSManagedObjectID {}
@end

@interface _AlbumList : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AlbumListID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* uid;

@property (atomic) int64_t uidValue;
- (int64_t)uidValue;
- (void)setUidValue:(int64_t)value_;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

+ (NSArray*)fetchAlbumListFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ ;
+ (NSArray*)fetchAlbumListFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_;

@end

@interface _AlbumList (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveUid;
- (void)setPrimitiveUid:(NSNumber*)value;

- (int64_t)primitiveUidValue;
- (void)setPrimitiveUidValue:(int64_t)value_;

@end
