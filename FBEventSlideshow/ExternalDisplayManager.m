//
//  ExternalDisplayManager.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/24.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "ExternalDisplayManager.h"

@implementation ExternalDisplayManager


#pragma mark - Singleton

+ (ExternalDisplayManager *)sharedManager
{
    static ExternalDisplayManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ExternalDisplayManager new];
    });
    return _sharedManager;
}

@end
