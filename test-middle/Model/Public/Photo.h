#import "_Photo.h"

@interface Photo : _Photo {}

+ (instancetype)photoWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
