//
//  UIFont+Styles.m
//  test-middle
//
//  Created by Андрей on 25.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "UIFont+Styles.h"

@implementation UIFont (Styles)

+ (instancetype)thinFontWithSize:(CGFloat)size {
    return [self fontWithName:@"HelveticaNeue-Thin" size:size];
}

+ (instancetype)lightFontWithSize:(CGFloat)size {
    return [self fontWithName:@"HelveticaNeue-Lignt" size:size];
}

@end
