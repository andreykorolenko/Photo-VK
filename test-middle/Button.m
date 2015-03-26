//
//  Button.m
//  test-middle
//
//  Created by Андрей on 25.03.15.
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
        self.titleLabel.font = [UIFont lightFontWithSize:5.f];
        self.layer.borderWidth = 1.f;
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
            [self setBackgroundImage:[UIImage imageNamed:@"teakColor"] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor teakColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            self.layer.borderColor = [UIColor teakColor].CGColor;
            self.userInteractionEnabled = YES;
            break;
        case ButtonFullColor:
            [self setBackgroundImage:[UIImage imageNamed:@"teakColor"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.layer.borderColor = [UIColor teakColor].CGColor;
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
