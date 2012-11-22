//
//  SlideshowViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/21.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "SlideshowViewController.h"
#import "PhotoViewController.h"



@interface SlideshowViewController ()
@property (nonatomic, strong) PhotoViewController *currentPhotoViewController;
@property (nonatomic, strong) PhotoViewController *nextPhotoViewController;
@end



@implementation SlideshowViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)displayPhoto:(Photo*)photo
{
    self.nextPhotoViewController = [[PhotoViewController alloc] init];
    self.nextPhotoViewController.photo = photo;
    self.nextPhotoViewController.view.frame = self.view.frame;
    self.nextPhotoViewController.view.alpha = 0.0;
    [self.view addSubview:self.nextPhotoViewController.view];
    
    [self.nextPhotoViewController displayPhotoWithCompletion:^(BOOL success) {
        
        [self.nextPhotoViewController animatePhotoDisplay];
        
        [UIView animateWithDuration:self.fadeInFadeOutDuration animations:^{
            self.nextPhotoViewController.view.alpha = 1.0;
            self.currentPhotoViewController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.currentPhotoViewController.view removeFromSuperview];
            self.currentPhotoViewController = self.nextPhotoViewController;
            self.nextPhotoViewController = nil;
        }];
    }];
}



@end
