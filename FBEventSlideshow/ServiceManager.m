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

@synthesize eventID = _eventID;


- (BOOL)facebookLoginWithUI:(BOOL)allowUI completion:(ServiceManagerHandler)completion
{
    return [FBSession openActiveSessionWithReadPermissions:@[@"user_photos"]
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


- (void)loadEventWithID:(NSString *)eventID completion:(ServiceManagerHandler)completion
{
    self.eventID = eventID;
    
    [FBRequestConnection startWithGraphPath:eventID completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSLog(@"Result: %@", result);
            completion(result, YES, nil);
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
    if (!self.eventID)
    {
        NSLog(@"Attempt to load event but there's no event ID!");
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/photos", self.eventID];
    NSLog(@"Loading photos from: %@", path);
    
    [FBRequestConnection startWithGraphPath:path completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSLog(@"Result: %@", result);
            completion(result, YES, nil);
        }
        else
        {
            NSLog(@"FBRequest failed with error: %@", error);
            completion(nil, NO, error);
        }
    }];
}


#pragma mark - Event ID

- (void)setEventID:(NSString *)eventID
{
    _eventID = eventID;
    [[NSUserDefaults standardUserDefaults] setObject:eventID forKey:@"EventID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)eventID
{
    if (!_eventID)
    {
        _eventID = [[NSUserDefaults standardUserDefaults] objectForKey:@"EventID"];
    }
    return _eventID;
}


#pragma mark - Singleton

+ (ServiceManager *)sharedManager
{
    static ServiceManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ServiceManager new];
    });
    return _sharedManager;
}

@end
