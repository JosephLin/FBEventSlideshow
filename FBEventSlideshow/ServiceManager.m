//
//  ServiceManager.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/5/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ServiceManager.h"

NSString *const FBSessionDidLogoutNotification = @"FBSessionDidLogoutNotification";

//478629618821334


@implementation ServiceManager


#pragma mark - Login / Logout

- (BOOL)facebookLoginWithUI:(BOOL)allowUI completion:(ServiceManagerHandler)completion
{
    return [FBSession openActiveSessionWithReadPermissions:@[@"user_photos", @"read_stream"]
                                              allowLoginUI:allowUI
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             
                                             if ( session.isOpen )
                                             {
                                                 NSLog(@"Facebook login successed!");
                                                 if (completion)
                                                     completion(nil, YES, nil);
                                             }
                                             
                                             if (error)
                                             {
                                                 NSLog(@"Facebook not logged in. Error: %@", error);
                                                 if (completion)
                                                     completion(nil, NO, error);
                                             }
                                         }];
}

- (void)facebookLogout
{
    [FBSession.activeSession closeAndClearTokenInformation];
    NSLog(@"Facebook logout successed!");
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionDidLogoutNotification object:nil];
}


#pragma mark - Event

- (void)loadEventWithID:(NSString *)eventID completion:(ServiceManagerHandler)completion
{
    [FBRequestConnection startWithGraphPath:eventID completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSLog(@"Result: %@", result);
            self.event = (Event *)[Event objectWithDict:result inContext:[Event mainMOC]];
            [self.event save];
            
            completion(self.event, YES, nil);
        }
        else
        {
            NSLog(@"FBRequest failed with error: %@", error);
            completion(nil, NO, error);
        }
    }];
}

- (void)loadEventPhotosWithCompletion:(ServiceManagerHandler)completion
{
    if (!self.event)
    {
        NSLog(@"Attempt to load event but there's no event!");
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/photos", self.event.id];
    NSLog(@"Loading photos from: %@", path);
    
    [FBRequestConnection startWithGraphPath:path completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSLog(@"Result: %@", result);
            NSArray *photos = [Photo objectsWithArray:result[@"data"] inContext:[Photo mainMOC]];
            self.event.photos = [NSSet setWithArray:photos];
            
            // Newest first
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
            photos = [photos sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            completion(photos, YES, nil);
        }
        else
        {
            NSLog(@"FBRequest failed with error: %@", error);
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - Singleton

+ (ServiceManager *)sharedManager
{
    static ServiceManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ServiceManager new];
        
        NSArray *allEvents = [Event allObjectsInContext:[Event mainMOC]];
        if ([allEvents count]) {
            _sharedManager.event = allEvents[0];
        }
        
        if ([allEvents count] > 1)
        {
            NSLog(@"Warning: more than 1 events found: %@.", allEvents);
        }
    });
    return _sharedManager;
}

@end
