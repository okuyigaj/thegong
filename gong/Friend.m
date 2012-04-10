//
//  Friend.m
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Friend.h"


@implementation Friend

@dynamic displayName;
@dynamic emailAddress;
@dynamic relationship;
@dynamic userId;
@dynamic initial;
@dynamic friendshipId;

- (NSString *)initial {
  [self willAccessValueForKey:@"initial"];
  NSString *_initial = [self.displayName substringToIndex:1];
  [self didAccessValueForKey:@"initial"];
  return _initial;
}

@end
