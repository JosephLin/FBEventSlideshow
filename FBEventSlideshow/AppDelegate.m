//
//  AppDelegate.m
//  FBEventSlideshow
//
//  Created by Joseph Lin on 11/4/12.
//  Copyright (c) 2012 Joseph Lin. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookSDK.h"
#import "TestFlight.h"



@interface AppDelegate ()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"a482c79c1218cfc1d5415d78f75e4ff8_MTU4ODg5MjAxMi0xMS0yNCAwODowNjozMS45MjkxMDk"];

    return YES;
}
							
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark - Core Data stack

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FBEventSlideshow" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBEventSlideshow.sqlite"];
        
        NSError *error = nil;
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            NSLog(@"Incompatible persistent store. Removing old store at: %@", storeURL);
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

            // Retry
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
