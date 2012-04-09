//
//  ConfirmRegistrationViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunication.h"
#import "LoadingView.h"

@interface ConfirmRegistrationViewController : UIViewController <UITextFieldDelegate, ServerCommunicationDelegate, UIAlertViewDelegate, LoadingViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *resendCodeButton;
@property (nonatomic, retain) IBOutlet UIButton *backToRegistrationButton;
@property (nonatomic, retain) IBOutlet UIButton *activateEmailButton;
@property (nonatomic, retain) IBOutlet UITextField *activationCodeTextField;
@property (nonatomic, retain) IBOutlet LoadingView *loadingView;

@property (nonatomic, retain) ServerCommunication *serverComms;
@property (nonatomic, retain) NSString *emailAddress;

- (IBAction)activateEmail;
- (IBAction)backToRegistration;
- (IBAction)resendCode;

@end
