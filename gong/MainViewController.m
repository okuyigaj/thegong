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
  if (_isLoggedIn == 0) {
    //Check User Default.
    BOOL tmp = [[NSUserDefaults standardUserDefaults] boolForKey:@"GONG_IS_LOGGED_IN"];
    if (tmp) {
      _isLoggedIn = 1;
    } else {
      _isLoggedIn = -1;
    }
  }
  return (_isLoggedIn == 1);
}

- (void)setIsLoggedIn:(BOOL)isLoggedIn {
  if ((isLoggedIn && _isLoggedIn == -1) || (!isLoggedIn && _isLoggedIn == 1)) {
    [[NSUserDefaults standardUserDefaults] setBool:isLoggedIn forKey:@"GONG_IS_LOGGED_IN"];
    if (isLoggedIn) {
      _isLoggedIn = 1;
    } else {
      _isLoggedIn = -1;
    }
  }
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
