//
//  ConfirmRegistrationViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmRegistrationViewController.h"

@implementation ConfirmRegistrationViewController

@synthesize resendCodeButton, backToRegistrationButton, activateEmailButton, activationCodeTextField, loadingView;
@synthesize serverComms, emailAddress, passwordHash;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self activateEmail];
  return YES;
}

- (IBAction)activateEmail {

  self.serverComms = [[ServerCommunication alloc] init];
  self.serverComms.delegate = self;
  NSString *activationCode = self.activationCodeTextField.text;
  [self.serverComms authoriseWithAuthToken:activationCode forEmail:self.emailAddress];
  [self.activationCodeTextField resignFirstResponder];
  self.loadingView.loadingMessage = @"Activating";
  [self.loadingView showAnimated:YES];
}

- (IBAction)resendCode {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.serverComms = [[ServerCommunication alloc] init];
    self.serverComms.delegate = self;
    [self.serverComms resendAuthTokenToEmail:[userDefaults objectForKey:@"GONG_REGISTER_EMAIL"]];
    [self.activationCodeTextField resignFirstResponder];
    self.loadingView.loadingMessage = @"Resending";
    [self.loadingView showAnimated:YES];
    
}

- (IBAction)backToRegistration {
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GONG_REGISTER_WAITING_FOR_ACTIVATION"];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)authorisationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason {
  if (_trueOrFalse) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GONG_REGISTER_WAITING_FOR_ACTIVATION"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GONG_REGISTER_EMAIL"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GONG_REGISTER_DISPLAYNAME"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GONG_REGISTER_PASSWORDHASH"];
    self.loadingView.loadingMessage = @"Logging in";
    [self.serverComms loginWithEmailAddress:self.emailAddress andPassword:self.passwordHash];
  } else {
    [self.loadingView hideAnimated:YES];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:_reason delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    av.tag = 0;
    [av show];
  }
}


- (void)didResendAuthToken:(BOOL)_trueOrFalse withReason:(NSString *)_reason{
    if(_trueOrFalse){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Your authorisation token was successfully resent"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:_reason
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self.loadingView hideAnimated:YES];
}


- (void)loginWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason {
  if (_trueOrFalse) {
    [self.loadingView hideAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
  } else {
    [self.loadingView hideAnimated:YES];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:_reason delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    av.tag = 1;
    [av show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 0) {
    [self.activationCodeTextField becomeFirstResponder];
  } else {
    //Not really sure what to do here.
  }
}

- (void)LoadingViewCancelButtonWasPressed {
  [self.loadingView hideAnimated:YES];
  [self.activationCodeTextField becomeFirstResponder];
  [self.serverComms cancelCurrentTask];
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
  [self.activationCodeTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
