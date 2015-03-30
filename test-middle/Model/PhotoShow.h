//
//  PhotoShow.h
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "MWPhoto.h"

@class Photo;

@interface PhotoShow : MWPhoto

@property (nonatomic, strong) Photo *photoModel;

+ (instancetype)photoWithPhoto:(Photo *)photo;

@end
