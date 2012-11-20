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
    if (self.animationDuration == 0) {
        self.animationDuration = 5.0;
    }
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
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.imageView.frame = endRect;
    }];
}


@end
