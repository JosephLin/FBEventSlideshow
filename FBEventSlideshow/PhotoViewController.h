//
//  PhotoViewController.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+Utilities.h"


@interface PhotoViewController : UIViewController

@property (nonatomic, strong) Photo *photo;
@property (nonatomic) NSTimeInterval animationDuration;

- (void)displayPhotoWithCompletion:(void(^)(BOOL success))completion;
- (void)animatePhotoDisplay;

@end
