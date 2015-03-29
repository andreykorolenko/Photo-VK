#import "AlbumManager.h"
#import "Album.h"

@interface AlbumManager ()

// Private interface goes here.

@end

@implementation AlbumManager

+ (instancetype)managerWithArray:(NSArray *)array inContext:(NSManagedObjectContext *)context {
    if (!array) {
        return nil;
    }
    
    AlbumManager *manager = nil;
    NSArray *managers = [self fetchAlbumManagerFetchRequest:context];
    if (managers.count > 0) {
        manager = [managers firstObject];
    } else {
        manager = [self MR_createEntityInContext:context];
    }
    [manager updateWithArray:array inContext:context];
    return manager;
}

+ (instancetype)managerInContext:(NSManagedObjectContext *)context {
    NSArray *managers = [self fetchAlbumManagerFetchRequest:context];
    if (managers.count > 0) {
        return [managers firstObject];
    } else {
        return nil;
    }
}

+ (NSArray *)allAlbums {
    AlbumManager *manager = [self managerInContext:[NSManagedObjectContext defaultContext]];
    return [manager.albums array];
}

- (void)updateWithArray:(NSArray *)array inContext:(NSManagedObjectContext *)context {
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *eachDictionary in array) {
        Album *album = [Album albumWithDictionary:eachDictionary inContext:context];
        if (album) {
            [orderedSet addObject:album];
        }
    }
    self.albums = orderedSet;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSArray *allAlbums = [Album findAllInContext:context];
        for (Album *album in allAlbums) {
            if (!album.albumManager) {
                [album deleteEntityInContext:context];
            }
        }
    }];
}

@end
