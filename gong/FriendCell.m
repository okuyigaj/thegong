//
//  FriendCell.m
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

@synthesize friendRequestButton, friendEmailAddress, friendName, buttonTitle = _buttonTitle, friendshipId, delegate, relationship;


- (void)setButtonTitle:(NSString *)buttonTitle {
  _buttonTitle = buttonTitle;
  
  [self.friendRequestButton setTitle:buttonTitle forState: UIControlStateNormal];
  [self.friendRequestButton setTitle:buttonTitle forState: UIControlStateApplication];
  [self.friendRequestButton setTitle:buttonTitle forState: UIControlStateHighlighted];
  [self.friendRequestButton setTitle:buttonTitle forState: UIControlStateReserved];
  [self.friendRequestButton setTitle:buttonTitle forState: UIControlStateSelected];
  [self.friendRequestButton setTitle:buttonTitle forState: UIControlStateDisabled];
}


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
