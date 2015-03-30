//
//  SocialPostHelper.m
//  vedomosti
//
//  Created by Андрей on 30.03.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import "SocialPostHelper.h"
#import "VkontakteHelper.h"
#import "Photo.h"
#import <Social/Social.h>
#import <VKSdk/VKActivity.h>

@implementation SocialPostHelper

+ (void)postPhoto:(Photo *)photo fromViewController:(UIViewController *)fromViewController {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.originalSizeURL]];
    UIImage *shareImage = [UIImage imageWithData:imageData];
    NSArray *items = @[shareImage];
    
    NSArray *applicationActivities = nil;
    NSArray *excludeActivities = nil;
    
    BOOL vkIsAuthorizedBeforePost = [[VkontakteHelper sharedHelper] isAuthorized];
    
    applicationActivities = @[[VKActivity new]];
    excludeActivities = @[UIActivityTypePostToTwitter,
                          UIActivityTypePostToWeibo,
                          UIActivityTypeMessage,
                          UIActivityTypeAirDrop,
                          UIActivityTypePrint,
                          UIActivityTypeCopyToPasteboard,
                          UIActivityTypeAssignToContact,
                          UIActivityTypeSaveToCameraRoll,
                          UIActivityTypeAddToReadingList,
                          UIActivityTypePostToFlickr,
                          UIActivityTypePostToVimeo,
                          UIActivityTypePostToTencentWeibo];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:items
                                                        applicationActivities:applicationActivities];
    
    activityViewController.excludedActivityTypes = excludeActivities;
    
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if ([activityType isEqualToString:VKActivityTypePost]){
            if (!vkIsAuthorizedBeforePost && [[VkontakteHelper sharedHelper] isAuthorized]) {
                [[VkontakteHelper sharedHelper] updateUserNameWithComplitionBlock:nil];
            }
        }
    }];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
        UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
        popover.sourceView = fromViewController.view;
        popover.sourceView = [fromViewController.navigationItem.rightBarButtonItem valueForKey:@"view"];
    } else {
        [fromViewController presentViewController:activityViewController animated:YES completion:nil];
    }
}

@end
