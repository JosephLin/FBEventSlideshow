//
//  Photo.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Event, User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) User *from;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) Event *event;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addLikesObject:(User *)value;
- (void)removeLikesObject:(User *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
