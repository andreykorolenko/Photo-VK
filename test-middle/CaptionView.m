//
//  CaptionView.m
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "CaptionView.h"
#import "VkontakteHelper.h"
#import "PhotoShow.h"
#import "MWCommon.h"
#import "Photo.h"

#import "NSDate+Helper.h"

static CGFloat const kHeightCaptionView = 70.0;

@interface CaptionView ()

@property (nonatomic, strong) PhotoShow *photoShow;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isHaveLike;

@end

@implementation CaptionView

- (instancetype)initWithPhoto:(PhotoShow *)photo
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.photoShow = photo;
        self.barStyle = UIBarStyleBlackTranslucent;
        self.tintColor = nil;
        self.barTintColor = nil;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self setupCaption];
    }
    return self;
}

- (void)setupCaption {
//    UILabel *author = [[UILabel alloc] initWithFrame:CGRectZero];
//    author.translatesAutoresizingMaskIntoConstraints = NO;
//    author.font = [UIFont thinFontWithSize:20.f];
//    author.textColor = [UIColor whiteColor];
//    author.numberOfLines = 0;
//    author.text = [VkontakteHelper sharedHelper].login;
//    [self addSubview:author];
//    
//    UIView *infoView = [[UIView alloc] initWithFrame:CGRectZero];
//    infoView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:infoView];
//    
//    // лайки
//    UIView *likeBackround = [[UIView alloc] initWithFrame:CGRectZero];
//    likeBackround.translatesAutoresizingMaskIntoConstraints = NO;
//    [infoView addSubview:likeBackround];
//    
//    UITapGestureRecognizer *likeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLike:)];
//    [likeBackround addGestureRecognizer:likeGesture];
//    
//    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    likeImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    likeImageView.image = self.photoShow.photoModel.isUserLike.boolValue ? [UIImage imageNamed:@"icon_like_yes"] : [UIImage imageNamed:@"icon_like_no"];
//    self.isHaveLike = self.photoShow.photoModel.isUserLike.boolValue;
//    [likeBackround addSubview:likeImageView];
//    
//    UILabel *countLikes = [[UILabel alloc] initWithFrame:CGRectZero];
//    countLikes.translatesAutoresizingMaskIntoConstraints = NO;
//    countLikes.font = [UIFont regularFontWithSize:20.0];
//    countLikes.textColor = [UIColor whiteColor];
//    countLikes.text = [self.photoShow.photoModel.likes stringValue];
//    [infoView addSubview:countLikes];
//    
//    // дата
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    dateLabel.font = [UIFont thinFontWithSize:16.0];
//    dateLabel.textColor = [UIColor whiteColor];
//    dateLabel.textAlignment = NSTextAlignmentRight;
//    dateLabel.text = [NSDate stringFromDate:self.photoShow.photoModel.date];
//    [infoView addSubview:dateLabel];
//    
//    // map icon
//    UIView *backgroundMap = [[UIView alloc] initWithFrame:CGRectZero];
//    backgroundMap.translatesAutoresizingMaskIntoConstraints = NO;
//    //backgroundMap.backgroundColor = [UIColor purpleColor];
//    [self addSubview:backgroundMap];
//    
//    UIImageView *mapPinView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    mapPinView.translatesAutoresizingMaskIntoConstraints = NO;
//    mapPinView.alpha = 0.9;
//    mapPinView.image = [UIImage imageNamed:@"map_pin"];
//    [backgroundMap addSubview:mapPinView];
//
//    NSDictionary *views = NSDictionaryOfVariableBindings(author, infoView, likeBackround, likeImageView, countLikes, dateLabel, backgroundMap, mapPinView);
//    NSDictionary *metrics = @{@"side": @20, @"infoHeight": @25, @"likeSide": @35, @"widthButtons": @(kHeightCaptionView), @"pinSide": @12};
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[author][backgroundMap]" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[infoView][backgroundMap]" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[author][infoView(infoHeight)]-5-|" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backgroundMap(widthButtons)]-10-|" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundMap]|" options:0 metrics:metrics views:views]];
//    
//    // map
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-pinSide-[mapPinView]-pinSide-|" options:0 metrics:metrics views:views]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pinSide-[mapPinView]-pinSide-|" options:0 metrics:metrics views:views]];
//    
//    // likes
//    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeBackround(infoHeight)]-8-[countLikes][dateLabel]-10-|" options:0 metrics:metrics views:views]];
//    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dateLabel]-2-|" options:0 metrics:metrics views:views]];
//    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[likeBackround]|" options:0 metrics:metrics views:views]];
//    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countLikes]-2-|" options:0 metrics:metrics views:views]];
//    [likeBackround addConstraint:[NSLayoutConstraint constraintWithItem:likeImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:likeBackround attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [likeBackround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeImageView]" options:0 metrics:metrics views:views]];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(0, kHeightCaptionView);
}

@end
