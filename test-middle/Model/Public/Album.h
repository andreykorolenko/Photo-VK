#import "_Album.h"

@interface Album : _Album {}

+ (instancetype)albumWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;
- (void)updatePhotos:(NSArray *)photos inContext:(NSManagedObjectContext *)context;
- (NSArray *)allPhotos;

@end
