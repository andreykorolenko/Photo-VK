//
//  ListViewCell.h
//  test-middle
//
//  Created by Андрей on 27.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Album, Photo;

@interface ListViewCell : UITableViewCell

+ (instancetype)cellWithAlbum:(Album *)album;
+ (instancetype)cellWithPhoto:(Photo *)photo;

@end
