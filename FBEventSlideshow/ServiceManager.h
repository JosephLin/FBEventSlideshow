//
//  ServiceManager.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/5/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"
#import "Event+Utilities.h"
#import "Photo+Utilities.h"

extern NSString *const FBSessionDidLogoutNotification;

typedef void (^ServiceManagerHandler)(id response, BOOL success, NSError *error);



@interface ServiceManager : NSObject

@property (nonatomic, strong) Event *event;

- (BOOL)facebookLoginWithUI:(BOOL)allowUI completion:(ServiceManagerHandler)completion;
- (void)facebookLogout;
- (void)loadEventWithID:(NSString *)eventID completion:(ServiceManagerHandler)completion;
- (void)loadEventPhotosWithCompletion:(ServiceManagerHandler)completion;
+ (ServiceManager *)sharedManager;

@end
