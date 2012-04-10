//
//  MainViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize isLoggedIn = __isLoggedIn;
@synthesize logoutButton, friendsButton, gongButton;

- (BOOL)isLoggedIn {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"GONG_IS_LOGGED_IN"];
}

- (void)setIsLoggedIn:(BOOL)isLoggedIn {
  [[NSUserDefaults standardUserDefaults] setBool:isLoggedIn forKey:@"GONG_IS_LOGGED_IN"];
}

- (IBAction)logout {
  self.isLoggedIn = NO;
  [self performSegueWithIdentifier:@"ShowLoginRegisterView" sender:self];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GONG_USER_ID"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GONG_SESSION_KEY"];
}

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

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
  self.navigationController.navigationBarHidden = YES;
  self.navigationController.toolbarHidden = YES;
  if (!self.isLoggedIn) {
    [self performSegueWithIdentifier:@"ShowLoginRegisterView" sender:self];
  } else {
  }
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
