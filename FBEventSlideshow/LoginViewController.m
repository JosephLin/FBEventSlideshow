//
//  LoginViewController.m
//  FBEventSlideshow
//
//  Created by Sheuchyun on 12/11/11.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "LoginViewController.h"
#import "ServiceManager.h"



@interface LoginViewController ()

@end


@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)loginButtonTapped:(id)sender
{
    [[ServiceManager sharedManager] facebookLoginWithUI:YES completion:^(id response, BOOL success, NSError *error) {
        if (success)
        {
            [self showMainView];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)showMainView
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
