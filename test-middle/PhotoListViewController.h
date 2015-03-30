//
//  PhotoListViewController.h
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Album;

@interface PhotoListViewController : UIViewController

+ (instancetype)photoListWithAllAlbums;
+ (instancetype)photoListWithPhotosFromAlbum:(Album *)album;

@end
