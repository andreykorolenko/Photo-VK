//
//  TableViewCell.m
//  test-middle
//
//  Created by Андрей on 27.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "TableViewCell.h"
#import "Album.h"
#import "Photo.h"

#import "UIFont+Styles.h"
#import "UIImageView+AFNetworking.h"

@interface TableViewCell ()

@property (nonatomic, strong) __block UIImageView *photo;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *infoView;

@end

@implementation TableViewCell

+ (instancetype)cellWithAlbum:(Album *)album {
    return [[self alloc] initWithAlbum:album];
}

- (instancetype)initWithAlbum:(Album *)album
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createAndLayoutUI];
        [self addInfoFromAlbum:album];
    }
    return self;
}

+ (instancetype)cellWithPhoto:(Photo *)photo {
    return [[self alloc] initWithPhoto:photo];
}

- (instancetype)initWithPhoto:(Photo *)photo
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createAndLayoutUI];
        [self addInfoFromPhoto:photo];
    }
    return self;
}

- (void)createAndLayoutUI {
    self.photo = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photo.translatesAutoresizingMaskIntoConstraints = NO;
    self.photo.layer.cornerRadius = 35;
    self.photo.layer.masksToBounds = YES;
    self.photo.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.photo];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.numberOfLines = NO;
    self.nameLabel.font = [UIFont thinFontWithSize:18.f];
    [self.contentView addSubview:self.nameLabel];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.infoView];
    
    NSDictionary *views = @{@"photo": self.photo, @"name": self.nameLabel, @"info": self.infoView};
    NSDictionary *metrics = @{@"size": @70, @"side": @15, @"top": @10};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[photo(size)]-side-[name]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[photo]-side-[info]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[name][info(==name)]-top-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photo(size)]" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.photo
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
}

- (void)addInfoFromAlbum:(Album *)album {
    self.nameLabel.text = album.name;
    
    UILabel *countPhotoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    countPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    countPhotoLabel.numberOfLines = 0;
    countPhotoLabel.font = [UIFont thinFontWithSize:16.f];
    countPhotoLabel.text = [NSString stringWithFormat:@"%@ %@", album.countPhoto, [self stringPhotoCount:album.countPhoto]];
    [self.infoView addSubview:countPhotoLabel];
    
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[countPhotoLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(countPhotoLabel)]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countPhotoLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(countPhotoLabel)]];
    
    [self setImageFromURL:[NSURL URLWithString:album.imageURL]];
}

- (void)addInfoFromPhoto:(Photo *)photo {
    self.nameLabel.text = @"Фото";
    
    UIView *like = [[UIView alloc] initWithFrame:CGRectZero];
    like.translatesAutoresizingMaskIntoConstraints = NO;
    like.backgroundColor = [UIColor purpleColor];
    [self.infoView addSubview:like];
    
    UILabel *countLikes = [[UILabel alloc] initWithFrame:CGRectZero];
    countLikes.translatesAutoresizingMaskIntoConstraints = NO;
    countLikes.font = [UIFont thinFontWithSize:16.0];
    countLikes.text = @"5";
    [self.infoView addSubview:countLikes];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(like, countLikes);
    NSDictionary *metrics = @{@"likeSide": @10};
    
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[like(likeSide)]" options:0 metrics:metrics views:views]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countPhotoLabel]|" options:0 metrics:metrics views:views]];
    
    [self setImageFromURL:[NSURL URLWithString:photo.imageURL]];
}

- (void)setImageFromURL:(NSURL *)URL {
    //[self.photo setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak UIImageView *weakPhoto = self.photo;
    
    [self.photo setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"]
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              weakPhoto.image = image;
                              //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
