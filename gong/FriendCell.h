//
//  FriendCell.h
//  gong
//
//  Created by Matthew Young on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendCell;

@protocol FriendCellDelegate <NSObject>

@optional
- (void)requestButtonPressedForFriendCell:(FriendCell *)cell;

@end

@interface FriendCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *friendName;
@property (nonatomic, retain) IBOutlet UILabel *friendEmailAddress;
@property (nonatomic, retain) IBOutlet UIButton *friendRequestButton;
@property (nonatomic, retain) NSString *friendshipId;
@property (nonatomic, assign) id<FriendCellDelegate> delegate;

- (IBAction)friendRequestButtonPressed;

@end
