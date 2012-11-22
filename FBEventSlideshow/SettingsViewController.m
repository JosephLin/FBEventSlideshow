//
//  FlipsideViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "SettingsViewController.h"
#import "ServiceManager.h"
#import "NSUserDefaults+Helper.h"



@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UITextField *idTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *photoDurationLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (strong, nonatomic) IBOutlet UIStepper *photoDurationStepper;
@property (strong, nonatomic) IBOutlet UIStepper *updateIntervalStepper;
@end



@implementation SettingsViewController

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idTextField.text = [ServiceManager sharedManager].event.id;
    self.nameLabel.text = [ServiceManager sharedManager].event.name;
    
    NSTimeInterval photoDuration = [NSUserDefaults standardUserDefaults].photoDuration;
    self.photoDurationLabel.text = [NSString stringWithFormat:@"%1.0f sec.", photoDuration];
    self.photoDurationStepper.value = photoDuration;
    
    NSTimeInterval updateInterval = [NSUserDefaults standardUserDefaults].updateInterval;
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"Every %1.0f sec.", updateInterval];
    self.updateIntervalStepper.value = updateInterval;
}


#pragma mark - Actions

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length])
    {
        [[ServiceManager sharedManager] loadEventWithID:self.idTextField.text completion:^(Event *event, BOOL success, NSError *error) {
            if (success)
            {
                self.nameLabel.text = event.name;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
}

- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    if (sender == self.photoDurationStepper)
    {
        self.photoDurationLabel.text = [NSString stringWithFormat:@"%1.0f sec.", sender.value];
    }
    else if (sender == self.updateIntervalStepper)
    {
        self.updateIntervalLabel.text = [NSString stringWithFormat:@"Every %1.0f sec.", sender.value];
    }
}

- (IBAction)stepperTouchUp:(UIStepper *)sender
{
    if (sender == self.photoDurationStepper)
    {
        [NSUserDefaults standardUserDefaults].photoDuration = sender.value;
    }
    else if (sender == self.updateIntervalStepper)
    {
        [NSUserDefaults standardUserDefaults].updateInterval = sender.value;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)logoutButtonTapped:(id)sender
{
    [[ServiceManager sharedManager] facebookLogout];
}


@end
