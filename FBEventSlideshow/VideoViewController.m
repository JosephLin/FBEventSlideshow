//
//  VideoViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/22.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>



@interface VideoViewController ()
@property (nonatomic, strong) NSArray *mediaItems;
@end



@implementation VideoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:@(MPMediaTypeMovie) forProperty:MPMediaItemPropertyMediaType];
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:predicate];
    
    self.mediaItems = [query items];
    [self.tableView reloadData];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mediaItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    
    MPMediaItem* item = self.mediaItems[indexPath.row];
    NSString* title = [item valueForProperty:MPMediaItemPropertyTitle];
    NSURL *URL = [item valueForProperty:MPMediaItemPropertyAssetURL];

    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
