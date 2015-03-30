//
//  FacebookHelper.h
//  vedomosti
//
//  Created by Михаил Любимов on 15.01.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "SocialHelper.h"

static NSString * const kLoginFacebook = @"kLoginFacebook";

@interface FacebookHelper : NSObject <SocialHelper>

@property (nonatomic, strong) FBSession *session;
@property (nonatomic, strong) NSString *login;

- (BOOL)isAuthorized;
- (void)updateUserNameWithComplitionBlock:(void (^)(void))completionBlock;
+ (BOOL)hasFBApp;

@end
