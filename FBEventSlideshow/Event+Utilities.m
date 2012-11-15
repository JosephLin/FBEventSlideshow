//
//  Event+Utilities.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 12/11/14.
//  Copyright (c) 2012年 Joseph Lin. All rights reserved.
//

#import "Event+Utilities.h"


@implementation Event (Utilities)

+ (NSManagedObject *)objectWithDict:(NSDictionary*)dict inContext:(NSManagedObjectContext*)context
{
    Event *event = (Event*)[super objectWithDict:dict inContext:context];
    event.name = dict[@"name"];

	return event;
}

@end
