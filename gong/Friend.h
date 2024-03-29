//
//  Friend.h
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSNumber * relationship;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * initial;
@property (nonatomic, retain) NSString * friendshipId;


@end
