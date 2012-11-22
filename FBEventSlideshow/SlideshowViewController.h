//
//  SlideshowViewController.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/21.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"


@interface SlideshowViewController : UIViewController

@property (nonatomic) NSTimeInterval fadeInFadeOutDuration;

- (void)displayPhoto:(Photo*)photo;

@end
