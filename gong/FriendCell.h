//
//  FriendCell.h
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *friendName;
@property (nonatomic, retain) IBOutlet UILabel *friendEmailAddress;
@property (nonatomic, retain) IBOutlet UIButton *friendRequestButton;

- (IBAction)friendRequestButtonPressed;

@end
