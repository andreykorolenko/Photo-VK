//
//  SocialHelper.h
//  vedomosti
//
//  Created by Михаил Любимов on 15.01.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthBlock)(NSString *accessToken, NSString *secret);

@protocol SocialHelper <NSObject>

+ (instancetype)sharedHelper;

- (void)authWithCompletionBlock:(AuthBlock)completionBlock;
- (void)deauth;

@end
