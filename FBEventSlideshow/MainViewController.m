//
//  MainViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "ServiceManager.h"
#import "UIImageView+WebCache.h"
#import "SlideshowViewController.h"
#import "AppDelegate.h"

#define kSlideshowDuration      5.0
#define kFadeInFadeOutDuration  0.5
#define kFeedRefreshInterval    20.0


@interface MainViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *settingsPopoverController;
@property (nonatomic, strong) NSMutableArray *slideshowViewControllers;
@property (nonatomic, strong) UIScreen *extScreen;
@property (nonatomic, strong) UIWindow *extWindow;
@property (nonatomic, strong) NSTimer *slideshowTimer;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSUInteger currentIndex;
@end



@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    // Slideshow view controller
    SlideshowViewController *controller = [SlideshowViewController new];
    controller.fadeInFadeOutDuration = kFadeInFadeOutDuration;
    controller.view.frame = self.view.bounds;
    [self.view insertSubview:controller.view atIndex:0];
    self.slideshowViewControllers = [NSMutableArray arrayWithObject:controller];
    
    
    
    // Login
    BOOL isLoggedIn = [[ServiceManager sharedManager] facebookLoginWithUI:NO completion:NULL];
    if (!isLoggedIn)
    {
        [self showLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSessionDidLogoutNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self.settingsPopoverController dismissPopoverAnimated:NO];
        [self showLogin];
    }];
    
    
    
    // External screen
    // No notifications are sent for screens that are present when the app is launched.
    [self screenDidChange:nil];
	
	// Register for screen connect and disconnect notifications.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDidChange:)
												 name:UIScreenDidConnectNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDidChange:)
												 name:UIScreenDidDisconnectNotification
											   object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([ServiceManager sharedManager].event)
    {
        [self loadEventPhotos];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.slideshowTimer invalidate];
    self.slideshowTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)showLogin
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}


#pragma mark - Photos

- (void)scheduleSlideshowTimer
{
    if (!self.slideshowTimer)
    {
        [self displayNextPhoto];
        self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:kSlideshowDuration target:self selector:@selector(displayNextPhoto) userInfo:nil repeats:YES];
    }
}

- (void)loadEventPhotos
{
    [[ServiceManager sharedManager] loadEventPhotosWithCompletion:^(NSArray *photos, BOOL success, NSError *error) {
        if (success)
        {
            self.photos = photos;
            [self scheduleSlideshowTimer];
            
            int64_t delayInSeconds = kFeedRefreshInterval;
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
        Photo *photo = self.photos[self.currentIndex];
        
        for (SlideshowViewController *controller in self.slideshowViewControllers)
        {
            [controller displayPhoto:photo];
        }
    }
    
    self.currentIndex++;
    if (self.currentIndex >= [self.photos count])
    {
        self.currentIndex = 0;
    }
}


#pragma mark - Flipside View Controller

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self loadEventPhotos];    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]])
    {
        ((UIStoryboardPopoverSegue *)segue).popoverController.delegate = self;
        self.settingsPopoverController = ((UIStoryboardPopoverSegue *)segue).popoverController;
    }
}


#pragma mark - External Display

- (void)screenDidChange:(NSNotification *)notification
{
	NSArray *screens = [UIScreen screens];
    NSLog(@"Found screens: %@", screens);
	
	
	if ([screens count] > 1)
    {
		// Select first external screen
		self.extScreen = screens[1];
        self.extScreen.currentMode = [self.extScreen.availableModes lastObject];
		
        if (!self.extWindow)
        {
            self.extWindow = [[UIWindow alloc] initWithFrame:self.extScreen.bounds];
            self.extWindow.screen = self.extScreen;
            
            SlideshowViewController *controller = [SlideshowViewController new];
            controller.fadeInFadeOutDuration = kFadeInFadeOutDuration;
            controller.view.frame = self.extWindow.bounds;
            controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.slideshowViewControllers addObject:controller];
            self.extWindow.rootViewController = controller;
            
            [self.extWindow makeKeyAndVisible];
        }
        
        self.extWindow.frame = self.extScreen.bounds;
	}
	else
    {
        [self.slideshowViewControllers removeObject:self.extWindow.rootViewController];
		self.extScreen = nil;
        self.extWindow = nil;
	}
}


@end
