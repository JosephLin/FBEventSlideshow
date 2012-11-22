//
//  PhotoViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "Comment+Utilities.h"
#import "NSUserDefaults+Helper.h"

#define kCellHeight 60.0;


@interface PhotoViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *orderedComments;
@end


@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
}

- (void)displayPhotoWithCompletion:(void(^)(BOOL success))completion
{
    if (!self.photo.source)
        return;
    
    
    NSString *URLString = self.photo.source;
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [self.imageView setImageWithURL:URL success:^(UIImage *image, BOOL cached) {
        
        completion(YES);
    } failure:^(NSError *error) {

        completion(NO);
    }];
    
    
    self.orderedComments = [self.photo orderedComments];
    NSUInteger rowCount = MIN([self.orderedComments count], 3);
    CGFloat height = rowCount * kCellHeight;
    
    if ([self.photo.name length])
    {
        self.titleLabel.text = self.photo.name;
        self.tableView.tableHeaderView = self.headerView;
        height += self.headerView.bounds.size.height;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    
    self.tableView.frame = CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height);
    [self.tableView reloadData];
}

- (void)animatePhotoDisplay
{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    CGFloat photoWidth = [self.photo.width floatValue];
    CGFloat photoHeight = [self.photo.height floatValue];
    
    CGFloat ratio = viewWidth / photoWidth;
    photoWidth *= ratio;
    photoHeight *= ratio;
    
    if (photoHeight < viewHeight)
    {
        ratio = viewHeight / photoHeight;
        photoWidth *= ratio;
        photoHeight *= ratio;
    }
    
    CGRect startRect = CGRectMake(0, 0, photoWidth, photoHeight);
    CGRect endRect = CGRectMake(viewWidth - photoWidth, viewHeight - photoHeight, photoWidth, photoHeight);

    self.imageView.frame = startRect;
    NSTimeInterval photoDuration = [NSUserDefaults standardUserDefaults].photoDuration;
    [UIView animateWithDuration:photoDuration animations:^{
        self.imageView.frame = endRect;
    }];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderedComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    Comment *comment = self.orderedComments[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:", comment.from.name];
    cell.detailTextLabel.text = comment.message;

    return cell;
}

@end
