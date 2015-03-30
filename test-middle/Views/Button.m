//
//  Button.m
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "Button.h"

@implementation Button

+ (instancetype)buttonWithColorType:(ButtonColorType)type text:(NSString *)text target:(id)target action:(SEL)action {
    return [[self alloc] initWithColorType:type text:text target:target action:action];
}

- (instancetype)initWithColorType:(ButtonColorType)type text:(NSString *)text target:(id)target action:(SEL)action {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self setTitle:text forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont thinFontWithSize:20.f];
        self.layer.borderWidth = 0.5;
        [self setColorType:type];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3;
    }
    return self;
}

- (void)setColorType:(ButtonColorType)colorType {
    switch (colorType) {
        case ButtonEmptyColor:
            [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"main_color"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.layer.borderColor = [UIColor mainColor].CGColor;
            self.userInteractionEnabled = YES;
            break;
        case ButtonFullColor:
            [self setBackgroundImage:[UIImage imageNamed:@"main_color"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.layer.borderColor = [UIColor mainColor].CGColor;
            self.userInteractionEnabled = YES;
            break;
        case ButtonGrayLockedColor:
            self.userInteractionEnabled = NO;
            [self setBackgroundImage:[UIImage imageNamed:@"grayColor"] forState:UIControlStateNormal];
            self.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
            break;
    }
}

@end
