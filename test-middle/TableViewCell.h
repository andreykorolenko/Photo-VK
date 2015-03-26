//
//  TableViewCell.h
//  test-middle
//
//  Created by Андрей on 27.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumList;

@interface TableViewCell : UITableViewCell

+ (instancetype)cellWithAlbum:(AlbumList *)album;

@end
