//
//  ViewController.h
//  gong
//
//  Created by James Penney1 on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunication.h"

@interface ViewController : UIViewController <ServerCommunicationDelegate, UITableViewDataSource, UITableViewDataSource, UITextFieldDelegate>{
    IBOutlet UITextField *txtAuthToken;
    IBOutlet UITableView *tblFriends;
    IBOutlet UITextField *txtNewFriend;
    NSMutableArray *friends;
    ServerCommunication *sc;
}

@property (nonatomic, retain) IBOutlet UITextField *txtAuthToken;
@property (nonatomic, retain) IBOutlet UITableView *tblFriends;
@property (nonatomic, retain) IBOutlet UITextField *txtNewFriend;
@property (nonatomic, retain) NSMutableArray *friends;
@property (nonatomic, retain) ServerCommunication *sc;

-(IBAction)registerDevice;
-(IBAction)tryRegistration;
-(IBAction)attemptLogin;
-(IBAction)getFriendsList;
-(IBAction)gongThoseBitches;

@end
