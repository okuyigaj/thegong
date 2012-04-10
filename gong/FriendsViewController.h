//
//  FriendsViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "FriendCell.h"
#import "ServerCommunication.h"

@interface FriendsViewController : UIViewController <ServerCommunicationDelegate, FriendCellDelegate, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *friendsTableView;
@property (nonatomic, retain) IBOutlet UITableView *requestsTableView;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *requestsButton;
@property (nonatomic, retain) IBOutlet UIButton *addFriendButton;
@property (nonatomic, retain) IBOutlet UIView *updatingFriendsView;


@property (nonatomic, retain) NSFetchedResultsController *allFriendsResultsController;
@property (nonatomic, retain) NSFetchedResultsController *requestsResultsController;

@property (nonatomic, assign) NSFetchedResultsController *activeResultsController;
@property (nonatomic, assign) UITableView *activeTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) ServerCommunication *serverComms;


- (IBAction)backToMainView;
- (IBAction)requestsButtonPressed;

@end
