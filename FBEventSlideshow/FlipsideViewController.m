//
//  FlipsideViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "FlipsideViewController.h"
#import "ServiceManager.h"



@interface FlipsideViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginLogoutButton;
@property (strong, nonatomic) IBOutlet UITextField *idTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@end



@implementation FlipsideViewController

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    [[ServiceManager sharedManager] loadEventWithID:textField.text completion:^(id response, BOOL success, NSError *error) {
        if (success)
        {
            self.nameLabel.text = [response objectForKey:@"name"];
            self.descriptionLabel.text = [response objectForKey:@"description"];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];

}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)loginLogoutButtonTapped:(id)sender
{
    [[ServiceManager sharedManager] facebookLoginWithCompletion:^(id response, BOOL success, NSError *error) {
        if (success)
        {
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

//#pragma mark - Table View
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.menuStructureArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	static NSString * cellIdentifier = @"BasicCell";
//	
//	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//	
//	if (cell == nil)
//	{
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//		cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//	
//	NSDictionary* menuDictionary = self.menuStructureArray[indexPath.row];
//    cell.textLabel.text = menuDictionary[@"title"];
//    
//    UIImage* iconImage = [UIImage imageNamed:menuDictionary[@"property"]];
//    cell.imageView.image = iconImage;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//	
//	NSDictionary* menuDictionary = self.menuStructureArray[indexPath.row];
//	NSString* viewControllerName = menuDictionary[@"viewController"];
//	Class aClass = [[NSBundle mainBundle] classNamed:viewControllerName];
//    
//	UIViewController* childVC = [[aClass alloc] init];
//    childVC.title = menuDictionary[@"title"];
//	if ( [childVC isKindOfClass:[ArrayBasedTableViewController class]] )
//	{
//		((ArrayBasedTableViewController*)childVC).property = self.menuStructureArray[indexPath.row][@"property"];
//	}
//    [self.navigationController pushViewController:childVC animated:YES];
//}

@end
