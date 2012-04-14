//
//  DataModel.m
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator, managedObjectModel = _managedObjectModel;

static DataModel *_sharedDataModel;


/**
  Returns the singleton model for this application
*/
+ (DataModel *)sharedDataModel {
  if (_sharedDataModel == nil) {
    _sharedDataModel = [[DataModel alloc] init];
  }
  return _sharedDataModel;
}

/**
  Returns a new ManagedObjectContext bound to the persistentStoreCoordinator.
 */
- (NSManagedObjectContext *)createManagedObjectContext
{
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  NSManagedObjectContext *context = nil;
  if (coordinator != nil)
  {
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
  }
  return context;
}
 
/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
 
    return _managedObjectModel;
}
 
/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
 
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
 
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GongDB.sqlite"];
 
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }  
 
    return _persistentStoreCoordinator;
}

- (void)resetStore {
  //delete the store.
  NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores objectAtIndex:0];
  NSError *error;
  NSURL *storeURL = store.URL;
  [self.persistentStoreCoordinator removePersistentStore:store error:&error];
  [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
  _persistentStoreCoordinator = nil;
}


/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
 
- (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    if (context != nil)
    {
        if ([context hasChanges] && ![context save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
