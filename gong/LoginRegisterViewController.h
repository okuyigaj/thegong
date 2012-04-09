//
//  LoginRegisterViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunication.h"
#import "LoadingView.h"

@interface LoginRegisterViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, ServerCommunicationDelegate, LoadingViewDelegate>


@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) UITextField *activeTextField;
@property (nonatomic, assign) UITextField *errorTextField;

@property (nonatomic, retain) IBOutlet UITextField *loginEmailTextField;
@property (nonatomic, retain) IBOutlet UITextField *loginPasswordTextField;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;

@property (nonatomic, retain) IBOutlet UITextField *registerDisplayNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *registerEmailTextField;
@property (nonatomic, retain) IBOutlet UITextField *registerPasswordTextField;
@property (nonatomic, retain) IBOutlet UITextField *registerPassword2TextField;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) NSString *passwordHash;

@property (nonatomic, retain) IBOutlet LoadingView *loadingView;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UIButton *loadingCancelButton;

@property (nonatomic, retain) ServerCommunication *serverComms;

NSString* md5(NSString *str, int salt);

- (IBAction)doLogin;
- (IBAction)doRegister;

- (BOOL)validateEmail:(NSString *)candidate;

@end
