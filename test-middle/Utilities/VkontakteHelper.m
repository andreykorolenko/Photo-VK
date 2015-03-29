//
//  VkontakteHelper.m
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "VkontakteHelper.h"
#import <VKSdk/VKSdk.h>

#import "AlbumManager.h"
#import "Album.h"
#import "Photo.h"

NSString * const AppID = @"4844768";
NSString * const kVKOwnerID = @"284922027";
//NSString * const kVKOwnerID = @"3845529"; // лу
//NSString * const kVKOwnerID = @"80074128"; // чулаков

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
    VKRequest *getAlbums = [VKRequest requestWithMethod:@"photos.getAlbums" andParameters:@{VK_API_OWNER_ID : kVKOwnerID, @"need_covers": @YES} andHttpMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [getAlbums executeWithResultBlock:^(VKResponse * response) {
        //NSLog(@"Json result: %@", response.json);
        
        __block AlbumManager *manager = nil;
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSArray *albums = OBJ_OR_NIL([(NSDictionary *)response.json objectForKey:@"items"], NSArray);
            
            if (albums) {
                manager = [AlbumManager managerWithArray:albums inContext:localContext];
            }
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
                 completion([AlbumManager allAlbums], nil, response);
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

- (void)getPhotosFromAlbum:(Album *)album withComplitionBlock:(RequestCompletionBlock)completion {
    VKRequest *getPhotos = [VKRequest requestWithMethod:@"photos.get" andParameters:@{VK_API_OWNER_ID : kVKOwnerID, VK_API_ALBUM_ID: album.uid, @"rev": @YES, @"extended": @YES} andHttpMethod:@"GET"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [getPhotos executeWithResultBlock:^(VKResponse * response) {
        //NSLog(@"Json result: %@", response.json);
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            NSArray *photos = OBJ_OR_NIL([(NSDictionary *)response.json objectForKey:@"items"], NSArray);
            
            if (photos) {
                [album updatePhotos:photos inContext:localContext];
            }
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
                completion([album allPhotos], nil, response);
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
        //NSLog(@"Json result: %@", response.json);
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

// загрузка изображения
- (void)downloadImageWithURL:(NSURL *)url onCompletion:(void(^)(UIImage *image, NSError *error))completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

//- (NSURLSessionDataTask *)downloadImageWithURLString:(NSString *)urlString onCompletion:(void(^)(UIImage *image, NSError *error))completion {
//    NSURLSessionDataTask *task = [self.imageSessionManager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        completion(responseObject, nil);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        completion(nil, error);
//    }];
//    [task resume];
//    return task;
//}

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
