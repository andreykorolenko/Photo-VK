//
//  PhotoListViewController.h
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoListType) {
    PhotoAlbumList,
    PhotoList
};

@interface PhotoListViewController : UIViewController

+ (instancetype)photoListWithType:(PhotoListType)listType;

@end
