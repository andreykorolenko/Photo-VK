#import "AlbumList.h"

@interface AlbumList ()

// Private interface goes here.

@end

@implementation AlbumList

+ (instancetype)albumListWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (!OBJ_OR_NIL(dictionary[@"id"], NSNumber)) {
        return nil;
    }
    
    AlbumList *album = nil;
    
    NSArray *albums = [self fetchAlbumListFetchRequest:context uid:OBJ_OR_NIL(dictionary[@"id"], NSNumber)];
    
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
    self.name = OBJ_OR_NIL(dictionary[@"title"], NSString);
    
    NSNumber *dateNumberSince = OBJ_OR_NIL(dictionary[@"created"], NSNumber);
    self.date = [NSDate dateWithTimeIntervalSince1970:[dateNumberSince longValue]];
    
    self.imageURL = OBJ_OR_NIL(dictionary[@"thumb_src"], NSString);
    
    // еще фото
}


@end
