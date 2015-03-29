// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumManager.h instead.

#import <CoreData/CoreData.h>

extern const struct AlbumManagerRelationships {
	__unsafe_unretained NSString *albums;
} AlbumManagerRelationships;

@class Album;

@interface AlbumManagerID : NSManagedObjectID {}
@end

@interface _AlbumManager : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AlbumManagerID* objectID;

@property (nonatomic, strong) NSOrderedSet *albums;

- (NSMutableOrderedSet*)albumsSet;

+ (NSArray*)fetchAlbumManagerFetchRequest:(NSManagedObjectContext*)moc_ ;
+ (NSArray*)fetchAlbumManagerFetchRequest:(NSManagedObjectContext*)moc_ error:(NSError**)error_;

@end

@interface _AlbumManager (AlbumsCoreDataGeneratedAccessors)
- (void)addAlbums:(NSOrderedSet*)value_;
- (void)removeAlbums:(NSOrderedSet*)value_;
- (void)addAlbumsObject:(Album*)value_;
- (void)removeAlbumsObject:(Album*)value_;

- (void)insertObject:(Album*)value inAlbumsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAlbumsAtIndex:(NSUInteger)idx;
- (void)insertAlbums:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAlbumsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAlbumsAtIndex:(NSUInteger)idx withObject:(Album*)value;
- (void)replaceAlbumsAtIndexes:(NSIndexSet *)indexes withAlbums:(NSArray *)values;

@end

@interface _AlbumManager (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableOrderedSet*)primitiveAlbums;
- (void)setPrimitiveAlbums:(NSMutableOrderedSet*)value;

@end
