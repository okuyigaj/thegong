//
//  AppDelegate.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectModel = _managedObjectModel,
            managedObjectContext = _managedObjectContext,
            persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Registering for push notifications...");    
    [[UIApplication sharedApplication] 
        registerForRemoteNotificationTypes:
        (UIRemoteNotificationTypeAlert | 
         UIRemoteNotificationTypeBadge | 
         UIRemoteNotificationTypeSound)];
    return YES;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
 
    NSString *str = [NSString 
        stringWithFormat:@"%@",deviceToken];
    NSLog(@"Device Token = %@",str);
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"GONG_DEVICE_TOKEN"]; 
}
 
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
 
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);    
 
}
 
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
 
- (void)saveContext
{
 
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark Core Data stack
 


@end
