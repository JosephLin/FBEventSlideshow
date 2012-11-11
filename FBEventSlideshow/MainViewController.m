//
//  MainViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "ServiceManager.h"
#import "UIImageView+WebCache.h"


@interface MainViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSTimer *slideshowTimer;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSUInteger currentIndex;
@end



@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isLoggedIn = [[ServiceManager sharedManager] facebookLoginWithUI:NO completion:NULL];
    
    if (!isLoggedIn)
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([ServiceManager sharedManager].eventID)
    {
        [self loadEventPhotos];
        
        self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(displayNextPhoto) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.slideshowTimer invalidate];
    self.slideshowTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)loadEventPhotos
{
    [[ServiceManager sharedManager] loadEventPhotosWithCompletion:^(id response, BOOL success, NSError *error) {
        if (success)
        {
            self.photos = response[@"data"];
            
            int64_t delayInSeconds = 30.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self loadEventPhotos];
            });
        }
    }];
}

- (void)displayNextPhoto
{
    if (self.currentIndex < [self.photos count])
    {
        NSString *URLString = self.photos[self.currentIndex][@"source"];
        NSURL *URL = [NSURL URLWithString:URLString];
        [self.imageView setImageWithURL:URL];
        self.currentIndex++;
    }
}


#pragma mark - Flipside View Controller

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self loadEventPhotos];
    
    self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(displayNextPhoto) userInfo:nil repeats:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]])
    {
        ((UIStoryboardPopoverSegue *)segue).popoverController.delegate = self;
    }
}


@end
