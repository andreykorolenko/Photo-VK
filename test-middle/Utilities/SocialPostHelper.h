//
//  SocialPostHelper.h
//  test-middle
//
//  Created by Андрей on 30.03.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface SocialPostHelper : NSObject

+ (void)postPhoto:(Photo *)photo fromViewController:(UIViewController *)fromViewController;

@end
