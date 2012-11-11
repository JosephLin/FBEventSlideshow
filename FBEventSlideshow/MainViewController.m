//
//  MainViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "MainViewController.h"
#import "ServiceManager.h"
#import "UIImageView+WebCache.h"

@interface MainViewController ()
@property (nonatomic, strong) NSTimer *slideshowTimer;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSUInteger currentIndex;
@end


@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
    
    [self loadEventPhotos];
    
    self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(displayNextPhoto) userInfo:nil repeats:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
