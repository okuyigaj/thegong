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

////////////// BUTTON FUNCTIONS

-(IBAction)tryRegistration{
    [sc registerWithUsername:@"jjpenney" email:@"someone@jpenney.com" andPassword:@"password"];
}

-(IBAction)tryAuth{
    [sc authoriseWithAuthToken:txtAuthToken.text forEmail:@"someone@jpenney.com"];
}

-(IBAction)attemptLogin{
    [sc loginWithEmailAddress:@"someone@jpenney.com" andPassword:@"password"];
}

-(IBAction)getFriendsList{
    [sc getFriendsList];
}

-(IBAction)addNewFriend{
    [sc addFriendWithEmailAddress:txtNewFriend.text];
}

-(void)deleteFriendAtIndex:(NSIndexPath *)indexPath{
    NSDictionary *tempDict = [self.friends objectAtIndex:indexPath.row];
    [sc deleteFriendWithFriendshipId:[tempDict objectForKey:@"friendship_id"]];
}

-(void)acceptFriendAtIndex:(NSIndexPath *)indexPath{
    NSDictionary *tempDict = [self.friends objectAtIndex:indexPath.row];
    [sc acceptFriendWithFriendshipId:[tempDict objectForKey:@"friendship_id"]];
}

-(IBAction)gongThoseBitches{
    [sc sendNotificationWithMessage:@"hello, this is a message" badge:@"18" andSound:@"default"];
}

///////////// END BUTTON FUNCTIONS



///////////// DELEGATE METHODS

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

-(void)didDeleteFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends{
    if (_trueOrFalse){
        NSLog(@"New Friends = %@",_friends);
        [self.friends removeAllObjects];
        for(NSDictionary *dict in _friends){
            [self.friends addObject:dict];
        }
        [self.tblFriends reloadData];
    }else{
        NSLog(@"Delete Friend Failed. Reason: %@",_reason);
        [self.tblFriends reloadData];
    }
}


-(void)didAcceptFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends{
    if (_trueOrFalse){
        NSLog(@"New Friends = %@",_friends);
        [self.friends removeAllObjects];
        for(NSDictionary *dict in _friends){
            [self.friends addObject:dict];
        }
        [self.tblFriends reloadData];
    }else{
        NSLog(@"Accept Friend Failed. Reason: %@",_reason);
    }
}

- (void)didNotifyFriends:(BOOL)_trueOrFalse withReason:(NSString *)_reason deliveryAttempts:(int)_attempts deliverySuccesses:(int)_successes{
    if (_trueOrFalse){
        NSLog(@"Deliveries attempted: %d, Deliveries succeeded: %d",_attempts, _successes);
    }else{
        NSLog(@"Notify friends failed. Reason: %@",_reason);
    }
}


///////////// END DELEGATE METHODS




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [friends count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *tempDict = [friends objectAtIndex:indexPath.row];
	cell.textLabel.text = [tempDict objectForKey:@"username"];
    
    if([[tempDict objectForKey:@"userOwned"]isEqualToString:@"yes"]
       &&[[tempDict objectForKey:@"verified"]isEqualToString:@"no"]){
        cell.detailTextLabel.text= @"Pending";
        
    }else if([[tempDict objectForKey:@"userOwned"]isEqualToString:@"no"]
             &&[[tempDict objectForKey:@"verified"]isEqualToString:@"no"]){
        cell.detailTextLabel.text= @"Accept?";
    }else{
        cell.detailTextLabel.text= @"Verified";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDict = [friends objectAtIndex:indexPath.row];
    
    if([[tempDict objectForKey:@"userOwned"]isEqualToString:@"no"]
       &&[[tempDict objectForKey:@"verified"]isEqualToString:@"no"]){
        [self acceptFriendAtIndex:indexPath];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [self.friends removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [self deleteFriendAtIndex:indexPath];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    sc = [[ServerCommunication alloc] init];
    [sc setDelegate:self];
    friends = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
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
