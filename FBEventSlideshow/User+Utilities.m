//
//  User+Utilities.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/15.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "User+Utilities.h"

@implementation User (Utilities)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    User *user = (User*)[super objectWithDict:dict inContext:context];
    user.name = dict[@"name"];
    
	return user;
}

@end
