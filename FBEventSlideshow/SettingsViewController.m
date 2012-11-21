//
//  FlipsideViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "SettingsViewController.h"
#import "ServiceManager.h"



@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UITextField *idTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
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

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)logoutButtonTapped:(id)sender
{
    [[ServiceManager sharedManager] facebookLogout];
}


@end
