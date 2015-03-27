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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createAndLayoutUIWithAlbum:(AlbumList *)album {
    
    __block UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectZero];
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
    
    UILabel *countPhotoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    countPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    countPhotoLabel.numberOfLines = 0;
    countPhotoLabel.font = [UIFont thinFontWithSize:16.f];
    countPhotoLabel.text = [NSString stringWithFormat:@"%@ %@", album.countPhoto, [self stringPhotoCount:album.countPhoto]];
    [self.contentView addSubview:countPhotoLabel];
    
    NSDictionary *views = @{@"photo": photo, @"name": name, @"countPhoto": countPhotoLabel};
    NSDictionary *metrics = @{@"size": @70, @"side": @15, @"top": @10};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[photo(size)]-side-[name]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[photo]-side-[countPhoto]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[name][countPhoto(==name)]-top-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photo(size)]" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:photo
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    //[photo setImageWithURL:[NSURL URLWithString:album.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURL *url = [NSURL URLWithString:album.imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak UIImageView *weakPhoto = photo;
    
    [photo setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"]
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakPhoto.image = image;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (NSString *)stringPhotoCount:(NSNumber *)count {
    NSString *stringCount = [count stringValue];
    NSString *lastCharacter = [stringCount substringFromIndex:stringCount.length - 1];
    NSString *twoLastCharacter = nil;
    if (stringCount.length > 1) {
        twoLastCharacter = [stringCount substringFromIndex:stringCount.length - 2];
    }
    
    // цифры, с особыми склонениями
    NSArray *exclusiveNumbers = @[@"11", @"12", @"13", @"14"];
    
    if ([@"567890" rangeOfString:lastCharacter].location != NSNotFound || [self haveString:twoLastCharacter inArray:exclusiveNumbers]) {
        return @"фотографий";
    } else if ([@"1" rangeOfString:lastCharacter].location != NSNotFound) {
        return @"фотография";
    } else {
        return @"фотографии";
    }
}

- (BOOL)haveString:(NSString *)searchString inArray:(NSArray *)array {
    for (NSString *string in array) {
        if ([string isEqualToString:searchString]) {
            return YES;
        }
    }
    return NO;
}

@end
