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
@property (nonatomic, strong) UIPopoverController *settingsPopoverController;
@property (nonatomic, strong) UIScreen *extScreen;
@property (nonatomic, strong) UIWindow *extWindow;
@property (nonatomic, strong) UIImageView *extImageView;
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
        [self showLogin];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:FBSessionDidLogoutNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self.settingsPopoverController dismissPopoverAnimated:NO];
        [self showLogin];
    }];
    
    
    
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
        
        if (!self.slideshowTimer)
        {
            self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(displayNextPhoto) userInfo:nil repeats:YES];
        }
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
        [self.imageView setImageWithURL:URL placeholderImage:self.imageView.image];
        [self.extImageView setImageWithURL:URL placeholderImage:self.imageView.image];
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
    
    if (!self.slideshowTimer)
    {
        self.slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(displayNextPhoto) userInfo:nil repeats:YES];
    }
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
    // 1. Use the screens class method of the UIScreen class to determine if an external display is available.
	NSArray *screens = [UIScreen screens];

    // Log the current screens and display modes
    NSUInteger screenCount = [screens count];
    NSLog(@"Device has %d screen(s).", screenCount);
    
	NSUInteger count = 0;
	for (UIScreen *screen in screens)
    {
		NSArray *displayModes = screen.availableModes;
		NSLog(@"Screen %d", count);

		for (UIScreenMode *mode in displayModes)
        {
			NSLog(@"Screen mode: %@", mode);
		}
		
		count++;
	}
	
	
	if (screenCount > 1)
    {
		// 2.
		// Select first external screen
		self.extScreen = screens[1];
        
        self.extScreen.currentMode = [self.extScreen.availableModes lastObject];
		
        if (self.extWindow == nil || !CGRectEqualToRect(self.extWindow.bounds, self.extScreen.bounds))
        {
            // Size of window has actually changed
            
            // 4.
            self.extWindow = [[UIWindow alloc] initWithFrame:self.extScreen.bounds];
            
            // 5.
            self.extWindow.screen = self.extScreen;
            
            self.extImageView = [[UIImageView alloc] initWithFrame:self.extWindow.frame];
            self.extImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.extWindow addSubview:self.extImageView];
            
            // 6.
            
            // 7.
            [self.extWindow makeKeyAndVisible];
        }
	}
	else
    {
		self.extScreen = nil;
        self.extWindow = nil;
	}
}


@end
