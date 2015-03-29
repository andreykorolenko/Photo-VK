#import "Photo.h"
#import "Album.h"

@interface Photo ()

// Private interface goes here.

@end

@implementation Photo

+ (instancetype)photoWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (!OBJ_OR_NIL(dictionary[@"id"], NSNumber)) {
        return nil;
    }
    
    Photo *photo = nil;
    NSArray *photos = [self fetchPhotosFetchRequest:context uid:OBJ_OR_NIL(dictionary[@"id"], NSNumber)];
    
    if (photos.count > 0) {
        photo = [photos firstObject];
    } else {
        photo = [self MR_createEntityInContext:context];
        photo.uid = OBJ_OR_NIL(dictionary[@"id"], NSNumber);
    }
    [photo updateWithDictionary:dictionary inContext:context];
    return photo;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    
    // название альбома
    //self.name = OBJ_OR_NIL(dictionary[@"title"], NSString);
    
    // дата создания
    NSNumber *dateNumberSince = OBJ_OR_NIL(dictionary[@"date"], NSNumber);
    self.date = [NSDate dateWithTimeIntervalSince1970:[dateNumberSince longValue]];
    
    // лайки
    NSDictionary *likes = dictionary[@"likes"];
    self.likes = likes[@"count"];
    
    // есть ли лайк пользователя
    self.isUserLike = likes[@"user_likes"];
    
    // small photo
    self.smallSizeURL = OBJ_OR_NIL(dictionary[@"photo_130"], NSString);
    
    // full photo
    self.originalSizeURL = OBJ_OR_NIL(dictionary[@"photo_1280"], NSString);
}

@end
