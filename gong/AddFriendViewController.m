//
//  AddFriendViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddFriendViewController.h"

@implementation AddFriendViewController

@synthesize addFriendButton, backButton, friendsEmailTextField, loadingView, serverComms;

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

- (void)viewWillAppear:(BOOL)animated {
  [self.friendsEmailTextField becomeFirstResponder];
}

- (IBAction)backToFriendList {
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self addFriend];
  return YES;
}

- (IBAction)addFriend {
  [self.friendsEmailTextField resignFirstResponder];
  self.loadingView.loadingMessage = @"Sending Request";
  [self.loadingView showAnimated:YES];
  self.serverComms = [[ServerCommunication alloc] init];
  self.serverComms.delegate = self;
  [self.serverComms addFriendWithEmailAddress:self.friendsEmailTextField.text];
}

- (void)didAddFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends {
  [self.loadingView hideAnimated:YES];
  if (_trueOrFalse) {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Request Sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    av.tag = 0;
    [av show];
  } else {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:_reason delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    av.tag = 1;
    [av show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 0) {
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    [self.friendsEmailTextField becomeFirstResponder];
  }
}

- (void)LoadingViewCancelButtonWasPressed {
  [self.serverComms cancelCurrentTask];
  [self.loadingView hideAnimated:YES];
  [self.friendsEmailTextField becomeFirstResponder];
}



#pragma mark - View lifecycle

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
