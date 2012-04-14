//
//  DataModel.h
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

@interface DataModel : NSObject



@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;

+ (DataModel *)sharedDataModel;
- (NSManagedObjectContext *)createManagedObjectContext;
- (void)resetStore;

@end
