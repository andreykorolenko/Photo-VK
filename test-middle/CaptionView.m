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
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectZero];
    author.translatesAutoresizingMaskIntoConstraints = NO;
    author.font = [UIFont thinFontWithSize:22.f];
    author.textColor = [UIColor whiteColor];
    author.numberOfLines = 0;
    author.text = [VkontakteHelper sharedHelper].login;
    [self addSubview:author];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectZero];
    infoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:infoView];
    
    // лайки
    UIView *likeBackround = [[UIView alloc] initWithFrame:CGRectZero];
    likeBackround.translatesAutoresizingMaskIntoConstraints = NO;
    [infoView addSubview:likeBackround];
    
    UITapGestureRecognizer *likeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLike:)];
    [likeBackround addGestureRecognizer:likeGesture];
    
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    likeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    likeImageView.image = self.photoShow.photoModel.isUserLike.boolValue ? [UIImage imageNamed:@"icon_like_yes"] : [UIImage imageNamed:@"icon_like_no"];
    self.isHaveLike = self.photoShow.photoModel.isUserLike.boolValue;
    [likeBackround addSubview:likeImageView];
    
    UILabel *countLikes = [[UILabel alloc] initWithFrame:CGRectZero];
    countLikes.translatesAutoresizingMaskIntoConstraints = NO;
    countLikes.font = [UIFont thinFontWithSize:18.0];
    countLikes.text = [self.photoShow.photoModel.likes stringValue];
    [infoView addSubview:countLikes];
    
    // кнопки
    UIView *backgroundShare = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundShare.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundShare.backgroundColor = [UIColor yellowColor];
    [self addSubview:backgroundShare];

    UIView *backgroundMap = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundMap.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundMap.backgroundColor = [UIColor purpleColor];
    [self addSubview:backgroundMap];

    NSDictionary *views = NSDictionaryOfVariableBindings(author, infoView, backgroundShare, backgroundMap, likeBackround, likeImageView, countLikes);
    NSDictionary *metrics = @{@"side": @20, @"infoHeight": @25, @"likeSide": @35, @"widthButtons": @(kHeightCaptionView)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[author][backgroundShare]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[infoView][backgroundShare]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[author][infoView(infoHeight)]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backgroundShare(widthButtons)][backgroundMap(widthButtons)]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundShare]|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundMap]|" options:0 metrics:metrics views:views]];
    
    // likes
    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeBackround(infoHeight)][countLikes]" options:0 metrics:metrics views:views]];
    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[likeBackround]|" options:0 metrics:metrics views:views]];
    [infoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countLikes]|" options:0 metrics:metrics views:views]];
    [likeBackround addConstraint:[NSLayoutConstraint constraintWithItem:likeImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:likeBackround attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [likeBackround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[likeImageView]" options:0 metrics:metrics views:views]];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(0, kHeightCaptionView);
}

#pragma mark - Gestures

- (void)tapLike:(UITapGestureRecognizer *)sender {
    self.isHaveLike = self.isHaveLike ? NO : YES;
    UIImageView *likeView = [sender.view.subviews firstObject];
    likeView.image = self.isHaveLike ? [UIImage imageNamed:@"icon_like_yes"] : [UIImage imageNamed:@"icon_like_no"];
}

@end
