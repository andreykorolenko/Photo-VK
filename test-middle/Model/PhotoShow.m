//
//  PhotoShow.m
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "PhotoShow.h"
#import "Photo.h"

@implementation PhotoShow

+ (instancetype)photoWithPhoto:(Photo *)photo {
    return [[self alloc] initWithPhoto:photo];
}

- (instancetype)initWithPhoto:(Photo *)photo
{
    self = [super initWithURL:[NSURL URLWithString:photo.originalSizeURL]];
    if (self) {
        self.photoModel = photo;
    }
    return self;
}

@end