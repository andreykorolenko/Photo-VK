//
//  VkontakteHelper.m
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "VkontakteHelper.h"
#import <VKSdk/VKSdk.h>

#import "AlbumList.h"
//#import "PhotoList.h"

NSString * const AppID = @"4844768";

@interface VkontakteHelper () <VKSdkDelegate>

@property (nonatomic, strong) AuthBlock authCompletionBlock;

@end

@implementation VkontakteHelper

+ (void)load {
    [VkontakteHelper sharedHelper];
}

+ (instancetype)sharedHelper {
    static dispatch_once_t pred;
    static VkontakteHelper *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
        shared.login = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginVK];
    });
    return shared;
}

- (BOOL)isAuthorized {
    return [VKSdk wakeUpSession];
}

- (void)getAlbumsWithComplitionBlock:(RequestCompletionBlock)completion {
    VKRequest *getAlbums = [VKRequest requestWithMethod:@"photos.getAlbums" andParameters:@{VK_API_OWNER_ID : @"80074128", @"need_covers": @YES} andHttpMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [getAlbums executeWithResultBlock:^(VKResponse * response) {
        NSLog(@"Json result: %@", response.json);
        
        NSMutableArray *localResults = [NSMutableArray array];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSArray *albums = OBJ_OR_NIL([(NSDictionary *)response.json objectForKey:@"items"], NSArray);
            for (NSDictionary *eachAlbum in albums) {
                AlbumList *albumList = [AlbumList albumListWithDictionary:eachAlbum inContext:localContext];
                if (albumList) {
                    [localResults addObject:albumList];
                }
            }
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
                 NSMutableArray *results = [NSMutableArray array];
                 for (AlbumList *album in localResults) {
                     [results addObject:[album inContext:[NSManagedObjectContext defaultContext]]];
                 }
                 completion(results, nil, response);
             } else {
                 completion(nil, error, response);
                 NSLog(@"%@", error.description);
             }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
         
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        } else {
            NSLog(@"VK error: %@", error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            completion(nil, error, nil);
        }
    }];
}

- (void)updateUserNameWithComplitionBlock:(void (^)(void))completionBlock {
    __typeof(self) __weak welf = self;
    VKRequest * meRequest = [[VKApi users] get];
    [meRequest executeWithResultBlock:^(VKResponse * response) {
        NSLog(@"Json result: %@", response.json);
        if ([response.json isKindOfClass:[NSArray class]]) {
            for (NSDictionary *eachUser in response.json) {
                NSString *firstName = [eachUser objectForKey:@"first_name"];
                NSString *lastName = [eachUser objectForKey:@"last_name"];
                welf.login = [NSString stringWithFormat:@"%@ %@",firstName, lastName];
                [[NSUserDefaults standardUserDefaults] setObject:welf.login forKey:kLoginVK];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if(completionBlock) {
                    completionBlock();
                }
            }
        }
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        }
        else {
            NSLog(@"VK error: %@", error);
        }
    }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [VKSdk initializeWithDelegate:self andAppId:AppID];
        [VKSdk instance];
        if (![VKSdk wakeUpSession]) {
            NSLog(@"Vkontakte wake up session fails");
        }
    }
    return self;
}

- (void)authWithCompletionBlock:(AuthBlock)completionBlock {
    self.authCompletionBlock = completionBlock;
    [VKSdk authorize:@[VK_PER_PHOTOS] revokeAccess:NO forceOAuth:NO inApp:NO];
}

- (void)deauth {
    [VKSdk forceLogout];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginVK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.login = nil;
}

#pragma mark - VKSdkDelegate

- (void)vkSdkRenewedToken:(VKAccessToken *)newToken {
    if (self.authCompletionBlock) {
        [self updateUserNameWithComplitionBlock:^{
            self.authCompletionBlock(newToken.accessToken, nil);
            self.authCompletionBlock = NULL;
        }];
    }
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    if (self.authCompletionBlock) {
        [self updateUserNameWithComplitionBlock:^{
            self.authCompletionBlock(newToken.accessToken, nil);
            self.authCompletionBlock = NULL;
        }];
    }
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    if (self.authCompletionBlock) {
        self.authCompletionBlock(nil, nil);
        self.authCompletionBlock = NULL;
    }
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(rootController.presentedViewController) {
        rootController = rootController.presentedViewController;
    }
    [rootController presentViewController:controller animated:YES completion:nil];
}

@end
