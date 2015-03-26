// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PhotoList.m instead.

#import "_PhotoList.h"

@implementation PhotoListID
@end

@implementation _PhotoList

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PhotoList" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PhotoList";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PhotoList" inManagedObjectContext:moc_];
}

- (PhotoListID*)objectID {
	return (PhotoListID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@end

