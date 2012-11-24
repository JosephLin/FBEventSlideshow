//
//  VideoViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/22.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "VideoListViewController.h"
#import <MediaPlayer/MediaPlayer.h>



@interface VideoListViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pauseButton;
@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerViewController;
@property (nonatomic, strong) NSArray *mediaItems;
@end



@implementation VideoListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:@(MPMediaTypeMovie) forProperty:MPMediaItemPropertyMediaType];
    
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate:predicate];
    
    self.mediaItems = [query items];
    [self.tableView reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackStateDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
       
        if (self.moviePlayerViewController.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
        {
            self.playButton.enabled = NO;
            self.pauseButton.enabled = YES;
        }
        else
        {
            self.playButton.enabled = YES;
            self.pauseButton.enabled = NO;
        }
    }];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mediaItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    
    MPMediaItem* item = self.mediaItems[indexPath.row];
    NSString* title = [item valueForProperty:MPMediaItemPropertyTitle];

    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.moviePlayerViewController)
    {
        if (self.extWindow) {
            [self.extWindow.rootViewController dismissMoviePlayerViewControllerAnimated];
        }
        else {
            [self dismissMoviePlayerViewControllerAnimated];
        }
    }
    
    MPMediaItem* item = self.mediaItems[indexPath.row];
    NSURL *URL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    self.moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
    
    // Hack
    NSString* title = [item valueForProperty:MPMediaItemPropertyTitle];
    BOOL isMV = [title rangeOfString:@"MV"].location != NSNotFound;
    self.moviePlayerViewController.moviePlayer.repeatMode = (isMV) ? MPMovieRepeatModeNone : MPMovieRepeatModeOne;
    
    if (self.extWindow)
    {
        self.moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.extWindow.rootViewController presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    }
    else
    {
        [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    }
}

- (IBAction)doneButtonTapped:(id)sender
{
    if (self.moviePlayerViewController){
        [self dismissMoviePlayerViewControllerAnimated];
        [self.extWindow.rootViewController dismissMoviePlayerViewControllerAnimated];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)playButtonTapped:(id)sender
{
    [self.moviePlayerViewController.moviePlayer play];
}

- (IBAction)pauseButtonTapped:(id)sender
{
    [self.moviePlayerViewController.moviePlayer pause];
}

- (IBAction)rewindButtonTapped:(id)sender
{
    self.moviePlayerViewController.moviePlayer.currentPlaybackTime = self.moviePlayerViewController.moviePlayer.initialPlaybackTime;
}

- (IBAction)fastForwardButtonTapped:(id)sender
{
    self.moviePlayerViewController.moviePlayer.currentPlaybackTime = self.moviePlayerViewController.moviePlayer.duration - 1;
//    [self.moviePlayerViewController.moviePlayer stop];
}

@end
