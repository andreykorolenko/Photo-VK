// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AlbumList.m instead.

#import "_AlbumList.h"

const struct AlbumListAttributes AlbumListAttributes = {
	.name = @"name",
	.uid = @"uid",
};

@implementation AlbumListID
@end

@implementation _AlbumList

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AlbumList" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AlbumList";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AlbumList" inManagedObjectContext:moc_];
}

- (AlbumListID*)objectID {
	return (AlbumListID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"uidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"uid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

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

+ (NSArray*)fetchAlbumListFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ {
	NSError *error = nil;
	NSArray *result = [self fetchAlbumListFetchRequest:moc_ uid:uid_ error:&error];
	if (error) {
#ifdef NSAppKitVersionNumber10_0
		[NSApp presentError:error];
#else
		NSLog(@"error: %@", error);
#endif
	}
	return result;
}
+ (NSArray*)fetchAlbumListFetchRequest:(NSManagedObjectContext*)moc_ uid:(NSNumber*)uid_ error:(NSError**)error_ {
	NSParameterAssert(moc_);
	NSError *error = nil;

	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];

	NSDictionary *substitutionVariables = [NSDictionary dictionaryWithObjectsAndKeys:

														uid_, @"uid",

														nil];

	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"AlbumListFetchRequest"
													 substitutionVariables:substitutionVariables];
	NSAssert(fetchRequest, @"Can't find fetch request named \"AlbumListFetchRequest\".");

	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}

@end

