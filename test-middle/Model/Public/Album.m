#import "Album.h"
#import "Photo.h"

@interface Album ()

// Private interface goes here.

@end

@implementation Album

+ (instancetype)albumWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (!OBJ_OR_NIL(dictionary[@"id"], NSNumber)) {
        return nil;
    }
    
    Album *album = nil;
    NSArray *albums = [self fetchAlbumsFetchRequest:context uid:OBJ_OR_NIL(dictionary[@"id"], NSNumber)];
    
    if (albums.count > 0) {
        album = [albums firstObject];
    } else {
        album = [self MR_createEntityInContext:context];
        album.uid = OBJ_OR_NIL(dictionary[@"id"], NSNumber);
    }
    [album updateWithDictionary:dictionary inContext:context];
    return album;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    
    // название альбома
    self.name = OBJ_OR_NIL(dictionary[@"title"], NSString);
    
    // дата создания
    NSNumber *dateNumberSince = OBJ_OR_NIL(dictionary[@"created"], NSNumber);
    self.date = [NSDate dateWithTimeIntervalSince1970:[dateNumberSince longValue]];
    
    // cover url
    self.coverURL = OBJ_OR_NIL(dictionary[@"thumb_src"], NSString);
    
    // количество фото
    self.countPhoto = OBJ_OR_NIL(dictionary[@"size"], NSNumber);
}

- (void)updatePhotos:(NSArray *)photos inContext:(NSManagedObjectContext *)context {
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *eachDictionary in photos) {
        Photo *photo = [Photo photoWithDictionary:eachDictionary inContext:context];
        if (photo) {
            [orderedSet addObject:photo];
        }
    }
    Album *album = [self inContext:context];
    album.photos = orderedSet;
}

- (NSArray *)allPhotos {
    Album *album = [self inContext:[NSManagedObjectContext defaultContext]];
    return [album.photos array];
}

@end
