//
//  ListViewCell.h
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Album, Photo;
@protocol ListViewCellDelegate;

@interface ListViewCell : UITableViewCell

+ (instancetype)cellWithAlbum:(Album *)album;
+ (instancetype)cellWithPhoto:(Photo *)photo delegate:(id <ListViewCellDelegate>)delegate;
- (void)updateLikeImage;

@end
