//
//  AppDelegate.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookSDK.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
							
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


@end
