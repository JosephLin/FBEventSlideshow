//
//  User.h
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Photo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *likedComments;
@property (nonatomic, retain) NSSet *likedPhotos;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addLikedCommentsObject:(Comment *)value;
- (void)removeLikedCommentsObject:(Comment *)value;
- (void)addLikedComments:(NSSet *)values;
- (void)removeLikedComments:(NSSet *)values;

- (void)addLikedPhotosObject:(Photo *)value;
- (void)removeLikedPhotosObject:(Photo *)value;
- (void)addLikedPhotos:(NSSet *)values;
- (void)removeLikedPhotos:(NSSet *)values;

@end
