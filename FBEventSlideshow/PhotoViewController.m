//
//  PhotoViewController.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"


@interface PhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end


@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    if ([self.photo.name length])
    {
        self.titleLabel.text = self.photo.name;
        self.titleLabel.hidden = NO;
    }
    else
    {
        self.titleLabel.hidden = YES;
    }
}


@end
