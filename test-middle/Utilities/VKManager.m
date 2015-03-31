//
//  VKManager.m
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "VKManager.h"
#import <VKSdk/VKSdk.h>

#import "AlbumManager.h"
#import "Album.h"
#import "Photo.h"

NSString * const AppID = @"4844768";

@interface VKManager () <VKSdkDelegate>

@property (nonatomic, strong) AuthBlock authCompletionBlock;

@end

@implementation VKManager

+ (void)load {
    [VKManager sharedHelper];
}

+ (instancetype)sharedHelper {
    static dispatch_once_t pred;
    static VKManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc] init];
        shared.login = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginVK];
        shared.ownerID = [[NSUserDefaults standardUserDefaults] objectForKey:kOwnerID];
    });
    return shared;
}

- (BOOL)isAuthorized {
    return [VKSdk wakeUpSession];
}

- (void)getAlbumsWithComplitionBlock:(RequestCompletionBlock)completion {
    VKRequest *getAlbums = [VKRequest requestWithMethod:@"photos.getAlbums" andParameters:@{VK_API_OWNER_ID : self.ownerID, @"need_covers": @YES} andHttpMethod:@"GET"];
    
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
        }];
         
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            //[error.vkError.request repeat];
            completion(nil, error, nil);
        } else {
            NSLog(@"VK error: %@", error);
            completion(nil, error, nil);
        }
    }];
}

- (void)getPhotosFromAlbum:(Album *)album withComplitionBlock:(RequestCompletionBlock)completion {
    VKRequest *getPhotos = [VKRequest requestWithMethod:@"photos.get" andParameters:@{VK_API_OWNER_ID : self.ownerID, VK_API_ALBUM_ID: album.uid, @"rev": @YES, @"extended": @YES} andHttpMethod:@"GET"];
    
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
        }];
        
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            //[error.vkError.request repeat];
            completion(nil, error, nil);
        } else {
            NSLog(@"VK error: %@", error);
            completion(nil, error, nil);
        }
    }];
}

- (void)postLike:(BOOL)like toPhotoID:(NSNumber *)uid withComplitionBlock:(RequestCompletionBlock)completion {
    NSString *method = like ? @"likes.add" : @"likes.delete";
    VKRequest *postLikes = [VKRequest requestWithMethod:method andParameters:@{VK_API_OWNER_ID : self.ownerID, @"type": @"photo", @"item_id": uid} andHttpMethod:@"POST"];
    
    [postLikes executeWithResultBlock:^(VKResponse * response) {
        NSArray *photos = [Photo fetchPhotosFetchRequest:[NSManagedObjectContext defaultContext] uid:uid];
        
        Photo *photo = nil;
        if (photos.count > 0) {
            photo = [photos firstObject];
        }
        
        like ? photo.likesValue++ : photo.likesValue--;
        photo.isUserLike = like ? @YES : @NO;
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        completion(photo.likes, nil, response);
        
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            //[error.vkError.request repeat];
            completion(nil, error, nil);
        } else {
            NSLog(@"VK error: %@", error);
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
                welf.ownerID = eachUser[@"id"];
                [[NSUserDefaults standardUserDefaults] setObject:welf.login forKey:kLoginVK];
                [[NSUserDefaults standardUserDefaults] setObject:welf.ownerID forKey:kOwnerID];
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
    [VKSdk authorize:@[VK_PER_PHOTOS, VK_PER_WALL] revokeAccess:NO forceOAuth:NO inApp:NO];
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
