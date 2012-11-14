//
//  Comment.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/14.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Like, Photo;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSManagedObject *from;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Event *event;
@end

@interface Comment (CoreDataGeneratedAccessors)

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
