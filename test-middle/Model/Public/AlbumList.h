#import "_AlbumList.h"

@interface AlbumList : _AlbumList {}

+ (instancetype)albumListWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
