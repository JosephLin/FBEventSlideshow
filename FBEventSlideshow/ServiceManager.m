//
//  ServiceManager.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/5/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "ServiceManager.h"
#import "FacebookSDK.h"


@implementation ServiceManager


- (void)facebookLoginWithCompletion:(ServiceManagerHandler)completion
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      
                                      if ( session.isOpen )
                                      {
                                          NSLog(@"Facebook login successed!");
                                          completion(nil, YES, nil);
                                      }
                                      
                                      if (error)
                                      {
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
