//
//  ViewController.m
//  gong
//
//  Created by James Penney1 on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize tblFriends;
@synthesize sc;
@synthesize txtAuthToken;
@synthesize friends;
@synthesize txtNewFriend;

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

-(IBAction)attemptLogin{
    [sc loginWithEmailAddress:@"j@jpenney.com" andPassword:@"password"];
}

-(IBAction)getFriendsList{
    [sc getFriendsList];
}

-(IBAction)addNewFriend{
    [sc addFriendWithEmailAddress:txtNewFriend.text];
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

-(void)loginWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason{
    if (_trueOrFalse){
        NSLog(@"Login Successful!");
    }else{
        NSLog(@"Login Failed. Reason: %@",_reason);
    }
}

-(void)didDownloadFriendsList:(BOOL)_trueOrFalse withReason:(NSString *)_reason andFriends:(NSArray *)_friends{
    if (_trueOrFalse){
        NSLog(@"Friends = %@",_friends);
        [self.friends removeAllObjects];
        for(NSDictionary *dict in _friends){
            [self.friends addObject:dict];
        }
        [self.tblFriends reloadData];
    }else{
        NSLog(@"Get Friends Failed. Reason: %@",_reason);
    }
}

-(void)didAddFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends{
    if (_trueOrFalse){
        NSLog(@"New Friends = %@",_friends);
        [self.friends removeAllObjects];
        for(NSDictionary *dict in _friends){
            [self.friends addObject:dict];
        }
        [self.tblFriends reloadData];
    }else{
        NSLog(@"Add Friend Failed. Reason: %@",_reason);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [friends count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *tempDict = [friends objectAtIndex:indexPath.row];
	cell.textLabel.text = [tempDict objectForKey:@"username"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    friends = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)displayDeviceToken:(NSNotification *)notification{
    NSLog(@"displaying device token");
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
