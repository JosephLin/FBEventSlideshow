//
//  NSUserDefaults+Helper.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/22.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "NSUserDefaults+Helper.h"

static NSString *kPhotoDurationKey = @"kPhotoDurationKey";
static NSString *kUpdateInterval = @"kUpdateInterval";

#define kDefaultPhotoDuration   10.0
#define kDefaultUpdateInterval  15.0



@implementation NSUserDefaults (Helper)

- (NSTimeInterval)photoDuration
{
    NSTimeInterval value = [self doubleForKey:kPhotoDurationKey];
    if (!value) {
        value = kDefaultPhotoDuration;
    }
    return value;
}

- (void)setPhotoDuration:(NSTimeInterval)photoDuration
{
    [self setDouble:photoDuration forKey:kPhotoDurationKey];
}

- (NSTimeInterval)updateInterval
{
    NSTimeInterval value = [self doubleForKey:kUpdateInterval];
    if (!value) {
        value = kDefaultUpdateInterval;
    }
    return value;
}

- (void)setUpdateInterval:(NSTimeInterval)updateInterval
{
    [self setDouble:updateInterval forKey:kUpdateInterval];
}

@end
