//
//  VideoViewController.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/22.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VideoListViewControllerDelegate <NSObject>
//@optional
@property (nonatomic, strong, readonly) UIWindow *extWindow;
@end

@interface VideoListViewController : UIViewController
@property (nonatomic, weak) id <VideoListViewControllerDelegate> delegate;
@end


