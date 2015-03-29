//
//  AuthViewController.m
//  test-middle
//
//  Created by Андрей on 25.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "AuthViewController.h"
#import "Button.h"
#import "VkontakteHelper.h"
#import "PhotoListViewController.h"

@interface AuthViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) Button *authButton;
@property (nonatomic, strong) Button *photoButton;
@property (nonatomic, strong) UIView *backgroundButtons;
@property (nonatomic, strong) NSLayoutConstraint *positionButtonsConstraint;
@property (nonatomic, strong) NSArray *logoConstraints;

@end

@implementation AuthViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];

    [self createAndLayoutUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // анимация появления кнопок
    [self.downView removeConstraint:self.positionButtonsConstraint];
    [self.downView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundButtons
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.downView
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0]];
    
    [UIView animateWithDuration:0.15 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLogoLayout];
}

// logo layout
- (void)updateLogoLayout {
    [self layoutLogoForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

#pragma mark - Layout UI

- (void)createAndLayoutUI {
    
    // up
    UIView *upView = [[UIView alloc] initWithFrame:CGRectZero];
    //upView.backgroundColor = [UIColor yellowColor];
    upView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:upView];
    
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoView.image = [UIImage imageNamed:@"logo"];
    [upView addSubview:self.logoView];
    
    // name
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.font = [UIFont thinFontWithSize:24.f];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.nameLabel];
    
    // down
    self.downView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.downView.backgroundColor = [UIColor yellowColor];
    self.downView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.downView];
    
    // buttons
    self.backgroundButtons = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundButtons.translatesAutoresizingMaskIntoConstraints = NO;
    //self.backgroundButtons.backgroundColor = [UIColor blueColor];
    [self.downView addSubview:self.backgroundButtons];
    
    self.authButton = [Button buttonWithColorType:ButtonEmptyColor text:@"" target:self action:nil];
    [self.backgroundButtons addSubview:self.authButton];
    
    self.photoButton = [Button buttonWithColorType:ButtonFullColor text:@"" target:self action:@selector(showAlbums)];
    [self.backgroundButtons addSubview:self.photoButton];
    
    //
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    //view1.backgroundColor = [UIColor redColor];
    [self.backgroundButtons addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    //view2.backgroundColor = [UIColor redColor];
    [self.backgroundButtons addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectZero];
    view3.translatesAutoresizingMaskIntoConstraints = NO;
    //view3.backgroundColor = [UIColor redColor];
    [self.backgroundButtons addSubview:view3];
    
    [self updateAuthUI];
    
    NSDictionary *views = @{@"upView": upView,
                            @"logoView": self.logoView,
                            @"nameLabel": self.nameLabel,
                            @"downView": self.downView,
                            @"backgroundButtons": self.backgroundButtons,
                            @"view1": view1,
                            @"view2": view2,
                            @"view3": view3,
                            @"testButton": self.authButton,
                            @"photoButton": self.photoButton};
    
    NSDictionary *metrics = @{@"side": @20,
                              @"heightLabel": @30,
                              @"heightButton": @50,
                              @"margin": @30};
    
    // layout up and down views
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[upView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[downView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameLabel]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[upView][nameLabel(heightLabel@20)][downView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[upView(downView)]" options:0 metrics:metrics views:views]];
    
    // layout logo
    [upView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoView
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:upView
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1.0
                                                        constant:0.0]];
    
    [upView addConstraint:[NSLayoutConstraint constraintWithItem:self.logoView
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:upView
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1.0
                                                        constant:0.0]];
    
    // layout buttons
    [self.downView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundButtons]|" options:0 metrics:metrics views:views]];
    
    [self.backgroundButtons addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[view1]-side-|" options:0 metrics:metrics views:views]];
    [self.backgroundButtons addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[view2]-side-|" options:0 metrics:metrics views:views]];
    [self.backgroundButtons addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[view3]-side-|" options:0 metrics:metrics views:views]];
    
    [self.backgroundButtons addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[testButton]-side-|" options:0 metrics:metrics views:views]];
    [self.backgroundButtons addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-side-[photoButton]-side-|" options:0 metrics:metrics views:views]];
    [self.backgroundButtons addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view1(>=20)][testButton(heightButton)][view2(view1)][photoButton(heightButton)][view3(view1)]|" options:0 metrics:metrics views:views]];
    
    self.positionButtonsConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundButtons
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.downView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0];
    [self.downView addConstraint:self.positionButtonsConstraint];
}

- (void)updateAuthUI {
    if ([[VkontakteHelper sharedHelper] isAuthorized]) {
        self.navigationItem.title = @"Профиль";
        [self.authButton setColorType:ButtonEmptyColor];
        [self.authButton setTitle:@"Выйти" forState:UIControlStateNormal];
        [self.authButton removeTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.authButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.photoButton setColorType:ButtonFullColor];
    } else {
        self.navigationItem.title = @"Авторизация";
        [self.authButton setColorType:ButtonFullColor];
        [self.authButton setTitle:@"Войти" forState:UIControlStateNormal];
        [self.authButton removeTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self.authButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.photoButton setColorType:ButtonGrayLockedColor];
    }
    NSString *userName = [VkontakteHelper sharedHelper].login;
    self.nameLabel.text = (userName) ? [NSString stringWithFormat:@"Привет, %@", userName] : @"Пожалуйста, авторизуйтесь";
    [self.photoButton setTitle:(userName) ? @"Просмотр фотоальбомов" : @"Фотоальбомы недоступны" forState:UIControlStateNormal];
}

#pragma mark - Authorization

- (void)login {
    [[VkontakteHelper sharedHelper] authWithCompletionBlock:^(NSString *accessToken, NSString *secret) {
        [self updateAuthUI];
    }];
}

- (void)logout {
    [[VkontakteHelper sharedHelper] deauth];
    [self updateAuthUI];
}

#pragma mark - Navigation

- (void)showAlbums {
    PhotoListViewController *listViewController = [PhotoListViewController photoListWithAllAlbums];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Orientation

- (void)layoutLogoForOrientation:(UIInterfaceOrientation)orientation {
    [self.view removeConstraints:self.logoConstraints];
    NSDictionary *views = @{@"logo": self.logoView};
    NSDictionary *metrics = @{@"max": @50, @"min": @10};
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.logoConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-min-[logo]-min-|" options:0 metrics:metrics views:views];
    } else {
        self.logoConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-max-[logo]-max-|" options:0 metrics:metrics views:views];
    }
    [self.view addConstraints:self.logoConstraints];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutLogoForOrientation:toInterfaceOrientation];
}

@end
