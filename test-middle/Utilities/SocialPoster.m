//
//  SocialPoster.m
//  vedomosti
//
//  Created by Андрей on 30.03.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import "SocialPoster.h"
#import <Social/Social.h>
#import <VKSdk/VKActivity.h>

#import "VKManager.h"
#import "Photo.h"

@implementation SocialPoster

+ (void)postPhoto:(Photo *)photo fromViewController:(UIViewController *)fromViewController {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.originalSizeURL]];
    UIImage *shareImage = [UIImage imageWithData:imageData];
    NSArray *items = @[shareImage];
    
    NSArray *applicationActivities = nil;
    NSArray *excludeActivities = nil;
    
    BOOL vkIsAuthorizedBeforePost = [[VKManager sharedHelper] isAuthorized];
    
    applicationActivities = @[[VKActivity new]];
    excludeActivities = @[UIActivityTypePostToWeibo,
                          UIActivityTypeMessage,
                          UIActivityTypeAirDrop,
                          UIActivityTypePrint,
                          UIActivityTypeCopyToPasteboard,
                          UIActivityTypeAssignToContact,
                          UIActivityTypeSaveToCameraRoll,
                          UIActivityTypeAddToReadingList,
                          UIActivityTypePostToTencentWeibo];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:items
                                                        applicationActivities:applicationActivities];
    
    activityViewController.excludedActivityTypes = excludeActivities;
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if ([activityType isEqualToString:VKActivityTypePost]){
            if (!vkIsAuthorizedBeforePost && [[VKManager sharedHelper] isAuthorized]) {
                [[VKManager sharedHelper] updateUserNameWithComplitionBlock:nil];
            }
        }
    }];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
        UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
        popover.sourceView = fromViewController.view;
        popover.sourceView = [fromViewController.navigationItem.rightBarButtonItem valueForKey:@"view"];
    } else {
        activityViewController.popoverPresentationController.sourceView = [fromViewController.navigationItem.rightBarButtonItem valueForKey:@"view"];
        [fromViewController presentViewController:activityViewController animated:YES completion:nil];
    }
}

@end
