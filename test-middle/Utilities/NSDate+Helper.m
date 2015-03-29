//
//  NSDate+Helper.m
//  vedomosti
//
//  Created by Андрей on 05.01.15.
//  Copyright (c) 2015 Sebbia. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

static NSDateFormatter *dateFromStringFormatter = nil;

+ (void)load {
    [self initializeDisplayFormatter];
}

+ (void)initializeDisplayFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFromStringFormatter = [[NSDateFormatter alloc] init];
        [dateFromStringFormatter setLocale:[NSLocale currentLocale]];
        [dateFromStringFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFromStringFormatter setDateFormat:@"dd MMMM yyyy"];
    });
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [dateFromStringFormatter stringFromDate:date];
}

@end