//
//  VkontakteHelper.h
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthBlock)(NSString *accessToken, NSString *secret);
typedef void (^RequestCompletionBlock)(id responseObject, NSError* error, VKResponse *response);

static NSString * const kLoginVK = @"kLoginVK";
@class Album;

@interface VkontakteHelper : NSObject

@property (nonatomic, strong) NSString *login;

+ (instancetype)sharedHelper;
- (void)authWithCompletionBlock:(AuthBlock)completionBlock;
- (void)getAlbumsWithComplitionBlock:(RequestCompletionBlock)completion;
- (void)getPhotosFromAlbum:(Album *)album withComplitionBlock:(RequestCompletionBlock)completion;
- (void)downloadImageWithURL:(NSURL *)url onCompletion:(void(^)(UIImage *image, NSError *error))completion;
//- (NSURLSessionDataTask *)downloadImageWithURLString:(NSString *)urlString onCompletion:(void(^)(UIImage *image, NSError *error))completion;
- (void)updateUserNameWithComplitionBlock:(void (^)(void))completionBlock;
- (void)deauth;
- (BOOL)isAuthorized;

@end
