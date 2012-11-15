//
//  Photo+Utilities.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/14.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "Photo+Utilities.h"
#import "NSDate+Utilities.h"


@implementation Photo (Utilities)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Photo *photo = (Photo*)[super objectWithDict:dict inContext:context];
    photo.name = dict[@"name"];
    photo.source = dict[@"source"];
    photo.width = dict[@"width"];
    photo.height = dict[@"height"];

    NSString *created_time = dict[@"created_time"];
    photo.createdTime = [NSDate dateFromServerString:created_time];

    photo.from = (User*)[User objectWithDict:dict[@"from"] inContext:context];
    
    NSArray *comments = dict[@"comments"][@"data"];
    photo.comments = [NSSet setWithArray:[Comment objectsWithArray:comments inContext:context]];

    NSArray *likes = dict[@"likes"][@"data"];
    photo.likes = [NSSet setWithArray:[User objectsWithArray:likes inContext:context]];
    
	return photo;
}

@end
