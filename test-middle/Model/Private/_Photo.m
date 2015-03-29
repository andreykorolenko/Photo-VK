// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.m instead.

#import "_Photo.h"

const struct PhotoAttributes PhotoAttributes = {
	.date = @"date",
	.isUserLike = @"isUserLike",
	.likes = @"likes",
	.originalSizeURL = @"originalSizeURL",
	.smallSizeURL = @"smallSizeURL",
	.uid = @"uid",
};

const struct PhotoRelationships PhotoRelationships = {
	.album = @"album",
};

@implementation PhotoID
@end

@implementation _Photo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Photo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc_];
}

- (PhotoID*)objectID {
	return (PhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isUserLikeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isUserLike"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"likesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"likes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"uidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"uid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic date;

@dynamic isUserLike;

- (BOOL)isUserLikeValue {
	NSNumber *result = [self isUserLike];
	return [result boolValue];
}

- (void)setIsUserLikeValue:(BOOL)value_ {
	[self setIsUserLike:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsUserLikeValue {
	NSNumber *result = [self primitiveIsUserLike];
	return [result boolValue];
}

- (void)setPrimitiveIsUserLikeValue:(BOOL)value_ {
	[self setPrimitiveIsUserLike:[NSNumber numberWithBool:value_]];
}

@dynamic likes;

- (int16_t)likesValue {
	NSNumber *result = [self likes];
	return [result shortValue];
}

- (void)setLikesValue:(int16_t)value_ {
	[self setLikes:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLikesValue {
	NSNumber *result = [self primitiveLikes];
	return [result shortValue];
}

- (void)setPrimitiveLikesValue:(int16_t)value_ {
	[self setPrimitiveLikes:[NSNumber numberWithShort:value_]];
}

@dynamic originalSizeURL;

@dynamic smallSizeURL;

@dynamic uid;

- (int64_t)uidValue {
	NSNumber *result = [self uid];
	return [result longLongValue];
}

- (void)setUidValue:(int64_t)value_ {
	[self setUid:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveUidValue {
	NSNumber *result = [self primitiveUid];
	return [result longLongValue];
}

- (void)setPrimitiveUidValue:(int64_t)value_ {
	[self setPrimitiveUid:[NSNumber numberWithLongLong:value_]];
}

@dynamic album;

+ (NSArray*)fetchPhotosFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ {
	NSError *error = nil;
	NSArray *result = [self fetchPhotosFetchRequest:moc_ uid:uid_ error:&error];
	if (error) {
#ifdef NSAppKitVersionNumber10_0
		[NSApp presentError:error];
#else
		NSLog(@"error: %@", error);
#endif
	}
	return result;
}
+ (NSArray*)fetchPhotosFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;

	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];

	NSDictionary *substitutionVariables = [NSDictionary dictionaryWithObjectsAndKeys:

														uid_, @"uid",

														nil];

	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"PhotosFetchRequest"
													 substitutionVariables:substitutionVariables];
	NSAssert(fetchRequest, @"Can't find fetch request named \"PhotosFetchRequest\".");

	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}

@end

