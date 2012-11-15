//
//  Comment+Utilities.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "Comment+Utilities.h"
#import "NSDate+Utilities.h"
#import "User+Utilities.h"


@implementation Comment (Utilities)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Comment *comment = (Comment*)[super objectWithDict:dict inContext:context];
    comment.message = dict[@"message"];
    comment.createdTime = [NSDate dateFromServerString:dict[@"created_time"]];
    comment.from = (User*)[User objectWithDict:dict[@"from"] inContext:context];
    
	return comment;
}

@end
