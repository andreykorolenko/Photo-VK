//
//  ListViewCell.m
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "ListViewCell.h"
#import "ListViewCellDelegate.h"

#import "Album.h"
#import "Photo.h"
#import "VKManager.h"

#import "UIFont+Styles.h"
#import "NSDate+Helper.h"
#import "UIImageView+AFNetworking.h"

@interface ListViewCell ()

@property (nonatomic, weak) id <ListViewCellDelegate> delegate;

@property (nonatomic, strong) __block UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *countLikes;
@property (nonatomic, assign) BOOL isHaveLike;

@property (nonatomic, strong) NSNumber *photoUID;

@end

@implementation ListViewCell

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

+ (instancetype)cellWithPhoto:(Photo *)photo delegate:(id <ListViewCellDelegate>)delegate {
    return [[self alloc] initWithPhoto:photo delegate:delegate];
}

- (instancetype)initWithPhoto:(Photo *)photo delegate:(id <ListViewCellDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.delegate = delegate;
        [self createAndLayoutUI];
        [self addInfoFromPhoto:photo];
    }
    return self;
}

- (void)createAndLayoutUI {
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoView.layer.cornerRadius = 35;
    self.photoView.layer.masksToBounds = YES;
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.photoView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.numberOfLines = NO;
    self.nameLabel.font = [UIFont thinFontWithSize:18.f];
    [self.contentView addSubview:self.nameLabel];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.infoView];
    
    NSDictionary *views = @{@"photo": self.photoView, @"name": self.nameLabel, @"info": self.infoView};
    NSDictionary *metrics = @{@"size": @70, @"side": @15, @"top": @10};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[photo(size)]-side-[name]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[photo]-side-[info]-side-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photo(size)]" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.photoView
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
    
    NSDictionary *views = @{@"contentView": self.contentView, @"name": self.nameLabel, @"info": self.infoView, @"countPhotoLabel": countPhotoLabel};
    NSDictionary *metrics = @{@"top": @10};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[name][info(==name)]-top-|" options:0 metrics:metrics views:views]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[countPhotoLabel]|" options:0 metrics:metrics views:views]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countPhotoLabel]|" options:0 metrics:metrics views:views]];
    
    [self setImageFromURL:[NSURL URLWithString:album.coverURL]];
}

- (void)addInfoFromPhoto:(Photo *)photo {
    
    self.photoUID = photo.uid; // для делегата
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    self.photoView.userInteractionEnabled = YES;
    [self.photoView addGestureRecognizer:tapGesture];
    
    UIView *likeBackround = [[UIView alloc] initWithFrame:CGRectZero];
    likeBackround.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoView addSubview:likeBackround];
    
    UITapGestureRecognizer *likeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLike:)];
    [likeBackround addGestureRecognizer:likeGesture];
    
    self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.likeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.isHaveLike = photo.isUserLike.boolValue;
    [self updateLikeImage];
    [likeBackround addSubview:self.likeImageView];
    
    self.countLikes = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countLikes.translatesAutoresizingMaskIntoConstraints = NO;
    self.countLikes.font = [UIFont thinFontWithSize:18.0];
    self.countLikes.text = [photo.likes stringValue];
    [self.infoView addSubview:self.countLikes];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dateLabel.font = [UIFont thinFontWithSize:16.0];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.text = [NSDate stringFromDate:photo.date];
    [self.infoView addSubview:dateLabel];
    
    NSDictionary *views = @{@"likeBackround": likeBackround, @"likeImageView": self.likeImageView, @"countLikes": self.countLikes, @"dateLabel": dateLabel, @"info": self.infoView};
    NSDictionary *metrics = @{@"likeSide": @35, @"top": @10};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[info]-top-|" options:0 metrics:metrics views:views]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeBackround(likeSide)][countLikes][dateLabel]|" options:0 metrics:metrics views:views]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[likeBackround]|" options:0 metrics:metrics views:views]];
    
    [likeBackround addConstraint:[NSLayoutConstraint constraintWithItem:self.likeImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:likeBackround attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [likeBackround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeImageView]" options:0 metrics:metrics views:views]];
    
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countLikes]|" options:0 metrics:metrics views:views]];
    [self.infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dateLabel]|" options:0 metrics:metrics views:views]];
    
    [self setImageFromURL:[NSURL URLWithString:photo.smallSizeURL]];
}

- (void)setImageFromURL:(NSURL *)URL {
    //[self.photo setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak UIImageView *weakPhoto = self.photoView;
    
    [self.photoView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"]
                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                              weakPhoto.image = image;
                              //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                          } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                          }];
}

#pragma mark - Gestures

- (void)selectPhoto:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userDidSelectPhoto:)]) {
        [self.delegate userDidSelectPhoto:self.photoUID];
    }
}

- (void)updateLikeImage {
    self.likeImageView.image = self.isHaveLike ? [UIImage imageNamed:@"icon_like_yes"] : [UIImage imageNamed:@"icon_like_no"];
}

- (void)tapLike:(UITapGestureRecognizer *)sender {
    self.isHaveLike = self.isHaveLike ? NO : YES;
    
    [self updateLikeImage];
    
    sender.enabled = NO;
    sender.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseOut animations:^{
        self.likeImageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished) {
        self.likeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        sender.view.userInteractionEnabled = YES;
        
    }];
    
    [[VKManager sharedHelper] postLike:self.isHaveLike toPhotoID:self.photoUID withComplitionBlock:^(NSNumber *likes, NSError *error, VKResponse *response) {
        // апдейт лайков
        self.countLikes.text = [likes stringValue];
        sender.enabled = YES;
    }];
}

#pragma mark - All Methods

- (NSString *)stringPhotoCount:(NSNumber *)count {
    NSString *stringCount = [count stringValue];
    NSString *lastCharacter = [stringCount substringFromIndex:stringCount.length - 1];
    NSString *twoLastCharacter = nil;
    if (stringCount.length > 1) {
        twoLastCharacter = [stringCount substringFromIndex:stringCount.length - 2];
    }
    
    // цифры, с особыми склонениями
    NSArray *exclusiveNumbers = @[@"11", @"12", @"13", @"14"];
    
    if ([[MCLocalization sharedInstance].language isEqualToString:@"ru"]) {
        if ([@"567890" rangeOfString:lastCharacter].location != NSNotFound || [self haveString:twoLastCharacter inArray:exclusiveNumbers]) {
            return [MCLocalization stringForKey:@"photo_declension_1"];
        } else if ([@"1" rangeOfString:lastCharacter].location != NSNotFound) {
            return [MCLocalization stringForKey:@"photo_declension_2"];
        } else {
            return [MCLocalization stringForKey:@"photo_declension_3"];
        }
    } else {
        if (count.integerValue == 1) {
            return [MCLocalization stringForKey:@"photo_declension_0"];
        } else {
            return [MCLocalization stringForKey:@"photo_declension_1"];
        }
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
