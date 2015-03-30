//
//  Button.h
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonColorType) {
    ButtonEmptyColor,
    ButtonFullColor,
    ButtonGrayLockedColor
};

@interface Button : UIButton

+ (instancetype)buttonWithColorType:(ButtonColorType)type text:(NSString *)text target:(id)target action:(SEL)action;
- (void)setColorType:(ButtonColorType)colorType;

@end
