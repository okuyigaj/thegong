//
//  ViewController.m
//  gong
//
//  Created by James Penney1 on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize lblDeviceToken;
@synthesize sc;
@synthesize txtAuthToken;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)registerDevice{
    NSLog(@"Registering for push notifications...");
    /// SHOULD BE DONE UPON STARTING
    [[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | 
      UIRemoteNotificationTypeBadge | 
      UIRemoteNotificationTypeSound)];
}

-(IBAction)tryRegistration{
    [sc registerWithUsername:@"jjpenney" email:@"j@jpenney.com" andPassword:@"password"];
}

-(IBAction)tryAuth{
    [sc authoriseWithAuthToken:txtAuthToken.text forEmail:@"j@jpenney.com"];
}

-(void)authorisationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason{
    if (_trueOrFalse){
        NSLog(@"Authorisation Successful!");
    }else{
        NSLog(@"Authorisation Failed. Reason: %@",_reason);
    }
}


-(void)registrationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason{
    if (_trueOrFalse){
        NSLog(@"Registration Successful!");
    }else{
        NSLog(@"Registration Failed. Reason: %@",_reason);
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayDeviceToken:) 
                                                 name:@"didReceiveDeviceToken"
                                               object:nil];
    sc = [[ServerCommunication alloc] init];
    [sc setDelegate:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)displayDeviceToken:(NSNotification *)notification{
    NSLog(@"displaying device token");
    NSDictionary *userInfo = [notification userInfo];
    lblDeviceToken.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"deviceToken"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
