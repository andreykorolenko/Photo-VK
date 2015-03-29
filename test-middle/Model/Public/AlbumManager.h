#import "_AlbumManager.h"

@interface AlbumManager : _AlbumManager {}

+ (instancetype)managerWithArray:(NSArray *)array inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allAlbums;

@end
