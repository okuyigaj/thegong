//
//  LoginRegisterViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginRegisterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ConfirmRegistrationViewController.h"

#define CC_MD5_DIGEST_LENGTH 16   /* digest length in bytes */

NSString* md5(NSString *str, int salt)
{   
  str = [NSString stringWithFormat:@"%@%d",str,salt];
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

@implementation LoginRegisterViewController

@synthesize scrollView, activeTextField, errorTextField, serverComms;
@synthesize loadingView, loadingLabel, loadingCancelButton;
@synthesize loginButton, loginEmailTextField, loginPasswordTextField;
@synthesize registerButton, registerEmailTextField, registerPasswordTextField, registerPassword2TextField, registerDisplayNameTextField;


- (void)textFieldDidBeginEditing:(UITextField *)textField {
  //scroll the view up so you can see the textField.
  if (textField.tag > 1) {
    //scroll the screen up so register is at the top.
    [self.scrollView setContentOffset:CGPointMake(0, 205) animated:YES];
  } else {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
  }
  self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  //scroll the view back down again.
  self.activeTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  UIView *nextView = [self.scrollView viewWithTag:textField.tag+1];
  if (nextView == nil) {
    if (textField.tag == 1) {
      [self doLogin];
    } else {
      [self doRegister];
    }
  } else {
    [nextView becomeFirstResponder];
  }
  return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)doLogin {
  //Check that they've entered a login and password.
  NSString *errorMessage = @"";
  self.errorTextField = nil;
  if (self.loginEmailTextField.text.length == 0) {
    errorMessage = @"Please enter your Email Address";
    self.errorTextField = self.loginEmailTextField;
  } else if (self.loginPasswordTextField.text.length == 0) {
    errorMessage = @"Please enter your Password";
    self.loginPasswordTextField.text = @"";
    self.errorTextField = self.loginPasswordTextField;
  }
  if (errorMessage != @"") {
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorView show];
  } else {
    //ACTUALLY DO LOGIN.
    [self.activeTextField resignFirstResponder];
    self.loadingView.loadingMessage = @"Logging in";
    [self.loadingView showAnimated:YES];
  }
}

- (IBAction)doRegister {
  //Do some checks before we do registration.
  NSString *errorMessage = @"";
  self.errorTextField = nil;
  //Check Display name has been entered.
  if (self.registerDisplayNameTextField.text.length == 0) {
    errorMessage = @"Please Enter a Display Name";
    self.errorTextField = self.registerDisplayNameTextField;
  } else if (![self validateEmail:self.registerEmailTextField.text]) {
    errorMessage = @"Please Enter a valid Email Address";
    self.errorTextField = self.registerEmailTextField;
  } else if (self.registerPasswordTextField.text.length < 6) {
    errorMessage = @"Please Enter a Password of at least 6 characters";
    self.errorTextField = self.registerPasswordTextField;
    self.registerPassword2TextField.text = @"";
    self.registerPasswordTextField.text = @"";
  } else if (![self.registerPasswordTextField.text isEqualToString:self.registerPassword2TextField.text]) {
    errorMessage = @"Passwords did not match";
    self.errorTextField = self.registerPasswordTextField;
    self.registerPasswordTextField.text = @"";
    self.registerPassword2TextField.text = @"";
  }
  
  if (errorMessage != @"") {
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorView show];
  } else {
    //DO REGISTRATION.
    [self.activeTextField resignFirstResponder];
    self.loadingView.loadingMessage = @"Registering";
    [self.loadingView showAnimated:YES];
    
    NSString *passwordHash = md5(self.registerPasswordTextField.text, PASSWORD_SALT);

    self.serverComms = [[ServerCommunication alloc] init];
    self.serverComms.delegate = self;
    [self.serverComms registerWithUsername:self.registerDisplayNameTextField.text email:self.registerEmailTextField.text andPassword:passwordHash];
  }
  
}

-(void)registrationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason {
  //Callback from registration server-comms.
  if (_trueOrFalse) {
    [self.loadingView hideAnimated:YES];
    [self performSegueWithIdentifier:@"ShowAuthorizeEmailView" sender:self];
  } else {
    [self.loadingView hideAnimated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:_reason delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  //Error message alert view dismissed, select the correct textfield.
  [self.errorTextField becomeFirstResponder];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

    return [emailTest evaluateWithObject:candidate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowAuthorizeEmailView"]) {
    //pass the users details accross.
    ConfirmRegistrationViewController *vc = segue.destinationViewController;
    vc.emailAddress = self.registerEmailTextField.text;
  }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  tap.delegate = self;
  [self.scrollView addGestureRecognizer:tap];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillHide:)
                                             name:UIKeyboardWillHideNotification
                                           object:nil];
  
}

- (void)LoadingViewCancelButtonWasPressed {
  [self.loadingView hideAnimated:YES];
  [self.serverComms cancelCurrentTask];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) keyboardWillHide:(NSNotification *)notification {
  [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateEnded) {
    [self.activeTextField resignFirstResponder];
  }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // test if our control subview is on-screen
    if ([touch.view isDescendantOfView:self.loginButton] ||
        [touch.view isDescendantOfView:self.registerButton] ||
        [touch.view isDescendantOfView:self.loadingCancelButton]) {
      return NO;
    } else {
      return YES;
    }
}




@end
