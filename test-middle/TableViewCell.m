//
//  TableViewCell.m
//  test-middle
//
//  Created by Андрей on 27.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "TableViewCell.h"
#import "AlbumList.h"

#import "UIFont+Styles.h"
#import "UIImageView+AFNetworking.h"

@implementation TableViewCell

+ (instancetype)cellWithAlbum:(AlbumList *)album {
    return [[self alloc] initWithAlbum:album];
}

- (instancetype)initWithAlbum:(AlbumList *)album
{
    self = [super init];
    if (self) {
        [self createAndLayoutUIWithAlbum:album];
    }
    return self;
}

- (void)createAndLayoutUIWithAlbum:(AlbumList *)album {
    
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectZero];
    photo.translatesAutoresizingMaskIntoConstraints = NO;
    photo.layer.cornerRadius = 35;
    photo.layer.masksToBounds = YES;
    photo.contentMode = UIViewContentModeScaleAspectFill;
    photo.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:photo];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectZero];
    name.translatesAutoresizingMaskIntoConstraints = NO;
    name.numberOfLines = NO;
    name.font = [UIFont thinFontWithSize:18.f];
    name.text = album.name;
    [self.contentView addSubview:name];
    
    NSDictionary *views = @{@"photo": photo, @"name": name};
    NSDictionary *metrics = @{@"size": @70, @"side": @20};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[photo(size)]-side-[name]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[name]|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photo(size)]" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:photo
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [photo setImageWithURL:[NSURL URLWithString:album.imageURL] placeholderImage:nil];
}

@end
