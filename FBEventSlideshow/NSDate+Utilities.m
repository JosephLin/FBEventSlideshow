//
//  NSDate+Utilities.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

+ (NSDateFormatter *)dateAndTimeFormatter
{
    static NSDateFormatter* _dateAndTimeFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateAndTimeFormatter = [NSDateFormatter new];
        _dateAndTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        _dateAndTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return _dateAndTimeFormatter;
}

+ (NSDate *)dateFromServerString:(NSString *)string
{
    NSDate* date = [[self dateAndTimeFormatter] dateFromString:string];    
    return date;
}
@end
