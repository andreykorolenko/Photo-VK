//
//  FacebookHelper.m
//  vedomosti
//
//  Created by Михаил Любимов on 15.01.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import "FacebookHelper.h"

@interface FacebookHelper ()

@end

@implementation FacebookHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t pred;
    static FacebookHelper *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
        shared.login = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginFacebook];
    });
    return shared;
}

- (BOOL)isAuthorized {
    FBSession *session = FBSession.activeSession;
    return session.state == FBSessionStateOpen || session.state == FBSessionStateCreatedTokenLoaded;
}
//
//- (void)iterateWidgets:(void (^)(id, int))iteratorBlock;

- (void)updateUserNameWithComplitionBlock:(void (^)(void))completionBlock {
    __typeof(self) __weak welf = self;
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            welf.login = [(NSDictionary *)result objectForKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:welf.login forKey:kLoginFacebook];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(completionBlock) {
                completionBlock();
            }
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

+ (BOOL)hasFBApp {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
}

- (void)authWithCompletionBlock:(AuthBlock)completionBlock {
    __typeof(self) __weak welf = self;
    if ([self.session isOpen]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(welf.session.accessTokenData.accessToken, nil);
        });
    } else {
        [self deauth];
        [self updateSession];
        [self.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (status == FBSessionStateOpen) {
                NSLog(@"success auth to facebook");
                [welf updateUserNameWithComplitionBlock:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(welf.session.accessTokenData.accessToken, nil);
                    });
                }];
            } else {
                NSLog(@"error auth to facebook");
                [welf deauth];
            }
        }];
    }
}

- (void)deauth {
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginFacebook];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -

- (void)updateSession {
    
    self.session = [[FBSession alloc] initWithAppID:nil
                                        permissions:[NSArray arrayWithObjects:
                                                                     @"user_about_me",
                                                                     @"user_birthday",
                                                                     @"publish_stream",
                                                                     @"offline_access",
                                                                     @"email",
                                                                     @"read_stream",
                                                                     @"publish_actions", nil]
                                    defaultAudience:FBSessionDefaultAudienceFriends
                                    urlSchemeSuffix:nil
                                 tokenCacheStrategy:nil];
    [FBSession setActiveSession:self.session];
}

@end
