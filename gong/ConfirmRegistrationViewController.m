//
//  ConfirmRegistrationViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfirmRegistrationViewController.h"

@implementation ConfirmRegistrationViewController

@synthesize resendCodeButton, backToRegistrationButton, activateEmailButton, activationCodeTextField;
@synthesize serverComms, emailAddress;

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
}

- (IBAction)backToRegistration {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)authorisationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason {
  if (_trueOrFalse) {
    
  } else {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:_reason delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self.activationCodeTextField becomeFirstResponder];
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
