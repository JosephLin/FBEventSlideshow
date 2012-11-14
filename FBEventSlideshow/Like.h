//
//  Like.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/14.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Like : NSManagedObject

@property (nonatomic, retain) NSManagedObject *from;
@property (nonatomic, retain) NSManagedObject *photo;
@property (nonatomic, retain) NSManagedObject *comment;

@end
