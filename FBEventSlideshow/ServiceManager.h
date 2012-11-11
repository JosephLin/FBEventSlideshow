//
//  ServiceManager.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/5/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ServiceManagerHandler)(id response, BOOL success, NSError *error);



@interface ServiceManager : NSObject

@property (nonatomic, strong) NSString *eventID;

- (void)facebookLoginWithCompletion:(ServiceManagerHandler)completion;
- (void)loadEventWithID:(NSString *)eventID completion:(ServiceManagerHandler)completion;
- (void)loadEventPhotosWithCompletion:(ServiceManagerHandler)completion;
+ (ServiceManager *)sharedManager;

@end
