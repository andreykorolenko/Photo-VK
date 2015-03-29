// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumManager.m instead.

#import "_AlbumManager.h"

const struct AlbumManagerRelationships AlbumManagerRelationships = {
	.albums = @"albums",
};

@implementation AlbumManagerID
@end

@implementation _AlbumManager

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AlbumManager" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AlbumManager";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AlbumManager" inManagedObjectContext:moc_];
}

- (AlbumManagerID*)objectID {
	return (AlbumManagerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic albums;

- (NSMutableOrderedSet*)albumsSet {
	[self willAccessValueForKey:@"albums"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"albums"];

	[self didAccessValueForKey:@"albums"];
	return result;
}

+ (NSArray*)fetchAlbumManagerFetchRequest:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchAlbumManagerFetchRequest:moc_ error:&error];
	if (error) {
#ifdef NSAppKitVersionNumber10_0
		[NSApp presentError:error];
#else
		NSLog(@"error: %@", error);
#endif
	}
	return result;
}
+ (NSArray*)fetchAlbumManagerFetchRequest:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;

	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];

	NSDictionary *substitutionVariables = [NSDictionary dictionary];

	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"AlbumManagerFetchRequest"
													 substitutionVariables:substitutionVariables];
	NSAssert(fetchRequest, @"Can't find fetch request named \"AlbumManagerFetchRequest\".");

	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}

@end

@implementation _AlbumManager (AlbumsCoreDataGeneratedAccessors)
- (void)addAlbums:(NSOrderedSet*)value_ {
	[self.albumsSet unionOrderedSet:value_];
}
- (void)removeAlbums:(NSOrderedSet*)value_ {
	[self.albumsSet minusOrderedSet:value_];
}
- (void)addAlbumsObject:(Album*)value_ {
	[self.albumsSet addObject:value_];
}
- (void)removeAlbumsObject:(Album*)value_ {
	[self.albumsSet removeObject:value_];
}
- (void)insertObject:(Album*)value inAlbumsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"albums"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self albums]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"albums"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"albums"];
}
- (void)removeObjectFromAlbumsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"albums"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self albums]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"albums"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"albums"];
}
- (void)insertAlbums:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"albums"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self albums]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"albums"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"albums"];
}
- (void)removeAlbumsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"albums"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self albums]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"albums"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"albums"];
}
- (void)replaceObjectInAlbumsAtIndex:(NSUInteger)idx withObject:(Album*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"albums"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self albums]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"albums"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"albums"];
}
- (void)replaceAlbumsAtIndexes:(NSIndexSet *)indexes withAlbums:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"albums"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self albums]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"albums"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"albums"];
}
@end

