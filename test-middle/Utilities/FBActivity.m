//
//  FBActivity.m
//  vedomosti
//
//  Created by Boris Bengus on 04.02.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import "FBActivity.h"
#import "FacebookHelper.h"
//#import "VDMShadowAlertView.h"

@interface FBActivity(){}

@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSURL *picture;

@end

@implementation FBActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}
- (NSString *)activityType {
    return FBActivityTypePost;
}
- (UIImage *)activityImage {
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        return [UIImage imageNamed:@"facebook_activity"];
    }
    return [UIImage imageNamed:@"facebook_activity_ios8"];
}
- (NSString *)activityTitle {
    return @"Facebook";
}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (UIActivityItemProvider *item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) return YES;
        else if ([item isKindOfClass:[NSString class]]) return YES;
        else if ([item isKindOfClass:[NSURL class]])    return YES;
    }
    return NO;
}
-(void)prepareWithActivityItems:(NSArray *)activityItems {
    self.link = nil;
    self.name = nil;
    self.caption = nil;
    self.desc = nil;
    self.picture = nil;
    
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            self.name = item;
        } else if([item isKindOfClass:[UIImage class]]) {
            
        } else if([item isKindOfClass:[NSURL class]]) {
            self.link = item;
        }
    }
}

- (void)performActivity {
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = self.link;
    params.name = self.name;
    BOOL canShare = [FBDialogs canPresentShareDialogWithParams:params];
    
    if ([FacebookHelper hasFBApp] && canShare) {
        // Show the facebook app's share dialog
        [FBDialogs presentShareDialogWithLink:self.link name:self.name caption:self.caption description:self.desc picture:self.picture clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if(error) {
                NSLog(@"Error: %@", error.description);
            } else {
                NSLog(@"Success!");
            }
        }];
    } else {
        NSLog(@"can't open facebook app...try to use webview...");
        // Show the webview share dialog
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if(self.name) {
            [params setObject:self.name forKey:@"name"];
        }
        if(self.caption) {
            [params setObject:self.caption forKey:@"caption"];
        }
        if(self.desc) {
            [params setObject:self.desc forKey:@"description"];
        }
        if(self.link) {
            [params setObject:self.link.absoluteString forKey:@"link"];
        }
        if(self.picture) {
            [params setObject:self.picture.absoluteString forKey:@"picture"];
        }
        
        if([[FacebookHelper sharedHelper] isAuthorized]) {
            [self publishWebWithParams:(NSDictionary *)params];
        } else {
            [[FacebookHelper sharedHelper] authWithCompletionBlock:^(NSString *accessToken, NSString *secret) {
                if (accessToken) {
                    [self publishWebWithParams:params];
                } else {
//                    [[VDMShadowAlertView alertWithText:@"Ошибка входа" type:VDMAlertViewInfo actionBlock:nil hideAfterTime:kShowAlertTime] showAlert];
                }
            }];
        }
    }
    
}

- (void)publishWebWithParams:(NSDictionary *)params {
    [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession] parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            NSLog(@"Error publishing story: %@", error.description);
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // User cancelled.
                NSLog(@"User cancelled.");
            } else {
                // Handle the publish feed callback
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                
                if (![urlParams valueForKey:@"post_id"]) {
                    // User cancelled.
                    NSLog(@"User cancelled.");
                    
                } else {
                    // User clicked the Share button
                    NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                    NSLog(@"result %@", result);
                }
            }
        }
    }];
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
-(UIViewController *)activityViewController {
    return nil;
}
@end
