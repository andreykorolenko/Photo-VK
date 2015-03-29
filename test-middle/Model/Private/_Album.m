// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Album.m instead.

#import "_Album.h"

const struct AlbumAttributes AlbumAttributes = {
	.countPhoto = @"countPhoto",
	.coverURL = @"coverURL",
	.date = @"date",
	.name = @"name",
	.uid = @"uid",
};

const struct AlbumRelationships AlbumRelationships = {
	.albumManager = @"albumManager",
	.photos = @"photos",
};

@implementation AlbumID
@end

@implementation _Album

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Album";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Album" inManagedObjectContext:moc_];
}

- (AlbumID*)objectID {
	return (AlbumID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"countPhotoValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"countPhoto"];
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

@dynamic countPhoto;

- (int16_t)countPhotoValue {
	NSNumber *result = [self countPhoto];
	return [result shortValue];
}

- (void)setCountPhotoValue:(int16_t)value_ {
	[self setCountPhoto:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCountPhotoValue {
	NSNumber *result = [self primitiveCountPhoto];
	return [result shortValue];
}

- (void)setPrimitiveCountPhotoValue:(int16_t)value_ {
	[self setPrimitiveCountPhoto:[NSNumber numberWithShort:value_]];
}

@dynamic coverURL;

@dynamic date;

@dynamic name;

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

@dynamic albumManager;

@dynamic photos;

- (NSMutableOrderedSet*)photosSet {
	[self willAccessValueForKey:@"photos"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"photos"];

	[self didAccessValueForKey:@"photos"];
	return result;
}

+ (NSArray*)fetchAlbumsFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ {
	NSError *error = nil;
	NSArray *result = [self fetchAlbumsFetchRequest:moc_ uid:uid_ error:&error];
	if (error) {
#ifdef NSAppKitVersionNumber10_0
		[NSApp presentError:error];
#else
		NSLog(@"error: %@", error);
#endif
	}
	return result;
}
+ (NSArray*)fetchAlbumsFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;

	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];

	NSDictionary *substitutionVariables = [NSDictionary dictionaryWithObjectsAndKeys:

														uid_, @"uid",

														nil];

	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"AlbumsFetchRequest"
													 substitutionVariables:substitutionVariables];
	NSAssert(fetchRequest, @"Can't find fetch request named \"AlbumsFetchRequest\".");

	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}

@end

@implementation _Album (PhotosCoreDataGeneratedAccessors)
- (void)addPhotos:(NSOrderedSet*)value_ {
	[self.photosSet unionOrderedSet:value_];
}
- (void)removePhotos:(NSOrderedSet*)value_ {
	[self.photosSet minusOrderedSet:value_];
}
- (void)addPhotosObject:(Photo*)value_ {
	[self.photosSet addObject:value_];
}
- (void)removePhotosObject:(Photo*)value_ {
	[self.photosSet removeObject:value_];
}
- (void)insertObject:(Photo*)value inPhotosAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"photos"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self photos]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"photos"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"photos"];
}
- (void)removeObjectFromPhotosAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"photos"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self photos]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"photos"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"photos"];
}
- (void)insertPhotos:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"photos"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self photos]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"photos"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"photos"];
}
- (void)removePhotosAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"photos"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self photos]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"photos"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"photos"];
}
- (void)replaceObjectInPhotosAtIndex:(NSUInteger)idx withObject:(Photo*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"photos"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self photos]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"photos"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"photos"];
}
- (void)replacePhotosAtIndexes:(NSIndexSet *)indexes withPhotos:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"photos"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self photos]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"photos"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"photos"];
}
@end

