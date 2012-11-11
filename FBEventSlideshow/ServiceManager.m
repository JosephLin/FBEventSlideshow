//
//  ServiceManager.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/5/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ServiceManager.h"
#import "FacebookSDK.h"

//478629618821334


@implementation ServiceManager


- (BOOL)facebookLoginWithUI:(BOOL)allowUI completion:(ServiceManagerHandler)completion
{
    return [FBSession openActiveSessionWithReadPermissions:@[@"user_photos"]
                                              allowLoginUI:allowUI
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             
                                             if ( session.isOpen )
                                             {
                                                 NSLog(@"Facebook login successed!");
                                                 completion(nil, YES, nil);
                                             }
                                             
                                             if (error)
                                             {
                                                 NSLog(@"Facebook not logged in. Error: %@", error);
                                                 completion(nil, NO, error);
                                             }
                                         }];
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
    NSString *path = [NSString stringWithFormat:@"%@/photos", self.eventID];
    
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
