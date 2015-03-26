// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PhotoList.h instead.

#import <CoreData/CoreData.h>
#import "AlbumList.h"

@interface PhotoListID : AlbumListID {}
@end

@interface _PhotoList : AlbumList {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoListID* objectID;

@end

@interface _PhotoList (CoreDataGeneratedPrimitiveAccessors)

@end
