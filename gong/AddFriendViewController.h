//
//  AddFriendViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunication.h"
#import "LoadingView.h"


@interface AddFriendViewController : UIViewController <UITextFieldDelegate, LoadingViewDelegate, ServerCommunicationDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *friendsEmailTextField;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *addFriendButton;
@property (nonatomic, retain) IBOutlet LoadingView *loadingView;

@property (nonatomic, retain) ServerCommunication *serverComms;

- (IBAction)backToFriendList;
- (IBAction)addFriend;

@end
