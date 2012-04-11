//
//  FriendCell.m
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

@synthesize friendRequestButton, friendEmailAddress, friendName, friendshipId, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)friendRequestButtonPressed {
  if ([delegate respondsToSelector:@selector(requestButtonPressedForFriendCell:)]) {
    [delegate requestButtonPressedForFriendCell:self];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
