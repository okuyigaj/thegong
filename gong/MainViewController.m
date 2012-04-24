//
//  MainViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "DataModel.h"

@implementation MainViewController

@synthesize isLoggedIn = __isLoggedIn;
@synthesize logoutButton, friendsButton, gongButton;
@synthesize serverComms = _serverComms;

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
  [[DataModel sharedDataModel] resetStore];
}

- (IBAction)hitGong:(id)sender {
    [self.serverComms sendNotificationWithMessage:@"Gong!" badge:@"18" andSound:@"gong.caf"];
  
    //Play the sound here too.
    AudioServicesPlaySystemSound(_gongSound);
}

- (void)didNotifyFriends:(BOOL)_trueOrFalse withReason:(NSString *)_reason deliveryAttempts:(int)_attempts deliverySuccesses:(int)_successes {
  if (_trueOrFalse) {
    NSLog(@"Success!");
  } else {
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
  self.navigationController.navigationBarHidden = YES;
  self.navigationController.toolbarHidden = YES;
  if (!self.isLoggedIn) {
    [self performSegueWithIdentifier:@"ShowLoginRegisterView" sender:self];
  } else {
  }
  self.serverComms = [[ServerCommunication alloc] init];
  self.serverComms.delegate = self;
}

- (void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout) 
                                                 name:@"logUserOut"
                                               object:nil];
    
    NSString *gongPath = [[NSBundle mainBundle] pathForResource:@"gong" ofType:@"caf"];
	NSURL *gongURL = [NSURL fileURLWithPath:gongPath];
    AudioServicesCreateSystemSoundID( (CFURLRef)objc_unretainedPointer(gongURL), &_gongSound);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"logUserOut"
                                                  object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
