//
//  FriendsViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITableView *friendsTableView;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *requestsButton;
@property (nonatomic, retain) IBOutlet UIButton *addFriendButton;


- (IBAction)backToMainView;

@end
