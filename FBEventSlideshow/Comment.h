//
//  Comment.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Photo, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) User *from;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) Photo *photo;
@property (nonatomic, retain) Event *event;
@end

@interface Comment (CoreDataGeneratedAccessors)

- (void)addLikesObject:(User *)value;
- (void)removeLikesObject:(User *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
