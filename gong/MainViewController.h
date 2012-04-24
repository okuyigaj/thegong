//
//  MainViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunication.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MainViewController : UIViewController <ServerCommunicationDelegate>{
    SystemSoundID _gongSound;
}

@property (nonatomic, assign) BOOL isLoggedIn;

@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) IBOutlet UIButton *friendsButton;
@property (nonatomic, retain) IBOutlet UIButton *gongButton;

@property (nonatomic, retain) ServerCommunication *serverComms;

- (IBAction)logout;
- (IBAction)hitGong:(id)sender;

@end
