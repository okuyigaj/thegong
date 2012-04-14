//
//  ServerCommunication.m
//  gong
//
//  Created by Matthew Young on 08/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerCommunication.h"
#import "SBJson.h"

@implementation ServerCommunication

@synthesize username, emailAddress, password, responseData, request, responseString;
@synthesize siteURL, delegate, action, connectionIsBusy = _connectionIsBusy, connection;

- (id)init {
  if (self = [super init]) {
    self.connectionIsBusy = NO;
    self.action = @"nothing";
    self.siteURL = @"http://www.immunis.co.uk/gong/";
  }
  return self;
}

- (void)setConnectionIsBusy:(BOOL)connectionIsBusy {
  if (connectionIsBusy) {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  } else {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  }
  _connectionIsBusy = connectionIsBusy;
}

- (void)updateLocalSessionKey:(NSString *)newKey{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:newKey forKey:@"GONG_SESSION_KEY"];
    [userDefaults synchronize];
}

- (void)storeUserId:(NSString *)userId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:@"GONG_USER_ID"];
    [userDefaults synchronize];
}

- (void)updateIsLoggedIn:(BOOL)newLoggedIn {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:newLoggedIn forKey:@"GONG_IS_LOGGED_IN"];
  [userDefaults synchronize];
}

- (void)registerWithUsername:(NSString *)_username email:(NSString *)_email andPassword:(NSString *)_password{
    if(self.connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = YES;
    self.username = _username;
    self.emailAddress = _email;
    self.password = _password;
    self.action = @"register";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_DEVICE_TOKEN"];
        
    NSString *post = [NSString stringWithFormat:@"action=register&username=%@&email=%@&password=%@&deviceToken=%@",
                      self.username,
                      self.emailAddress,
                      self.password,
                      deviceToken];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",self.siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)authoriseWithAuthToken:(NSString *)token forEmail:(NSString *)email{
    if(self.connectionIsBusy){
        [delegate authorisationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    
    self.action = @"auth";
    self.connectionIsBusy = YES;
        
    NSString *post = [NSString stringWithFormat:@"action=auth&email=%@&authToken=%@",
                      email, token];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",self.siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

- (void)loginWithEmailAddress:(NSString *)_email andPassword:(NSString *)_password{
    if(self.connectionIsBusy){
        [delegate loginWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = true;
    self.emailAddress = _email;
    self.password = _password;
    self.action = @"login";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_DEVICE_TOKEN"];
    
    NSString *post = [NSString stringWithFormat:@"action=login&email=%@&password=%@&deviceToken=%@",
                      self.emailAddress,
                      self.password,
                      deviceToken];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

- (void)getFriendsList{
    if(self.connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = true;
    self.action = @"getFriends";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_DEVICE_TOKEN"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_USER_ID"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_SESSION_KEY"];
    
    NSString *post = [NSString stringWithFormat:@"action=getFriends&userid=%@&sessionKey=%@&deviceToken=%@",
                      userId,
                      sessionKey,
                      deviceToken];
    
    NSLog(@"post = %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)addFriendWithEmailAddress:(NSString *)_email{
    if(self.connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = true;
    self.action = @"addFriend";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_USER_ID"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_SESSION_KEY"];
    
    NSString *post = [NSString stringWithFormat:@"action=addFriend&userid=%@&sessionKey=%@&email=%@",
                      userId,
                      sessionKey,
                      _email];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)deleteFriendWithFriendshipId:(NSString *)friendship_id{
    if(self.connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = true;
    self.action = @"delFriend";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_USER_ID"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_SESSION_KEY"];
    
    NSString *post = [NSString stringWithFormat:@"action=delFriend&userid=%@&sessionKey=%@&friendship_id=%@",
                      userId,
                      sessionKey,
                      friendship_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)acceptFriendWithFriendshipId:(NSString *)friendship_id{
    if(self.connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = true;
    self.action = @"delFriend";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_USER_ID"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_SESSION_KEY"];
    
    NSString *post = [NSString stringWithFormat:@"action=acceptFriend&userid=%@&sessionKey=%@&friendship_id=%@",
                      userId,
                      sessionKey,
                      friendship_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)sendNotificationWithMessage:(NSString *)msg badge:(NSString *)_badge andSound:(NSString *)_sound{
    if(self.connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = true;
    self.action = @"notify";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_USER_ID"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"GONG_SESSION_KEY"];
    
    NSString *post = [NSString stringWithFormat:@"action=notify&sender=%@&sessionKey=%@&msg=%@&badge=%@&sound=%@",
                      userId,
                      sessionKey,
                      msg,
                      _badge,
                      _sound];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  self.responseData = [[NSMutableData alloc] init];
	[self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connectionIsBusy = NO;
    
    if([self.action isEqualToString:@"register"]){
        [self.delegate registrationWasSuccessful:false withReason:@"Connection to server failed"];
    }else if([self.action isEqualToString:@"auth"]){
        [self.delegate authorisationWasSuccessful:false withReason:@"Connection to server failed"];        
    }else if([action isEqualToString:@"login"]){
        [delegate loginWasSuccessful:false withReason:@"Connection to server failed"];        
    }else if([action isEqualToString:@"getFriends"]){
        [delegate didDownloadFriendsList:false withReason:@"Connection to server failed" andFriends:nil];        
    }else if([action isEqualToString:@"addFriend"]){
        [delegate didAddFriend:false withReason:@"Connection to server failed" andNewFriendsList:nil];        
    }else if([action isEqualToString:@"delFriend"]){
        [delegate didDeleteFriend:false withReason:@"Connection to server failed" andNewFriendsList:nil];        
    }else if([action isEqualToString:@"acceptFriend"]){
        [delegate didAcceptFriend:false withReason:@"Connection to server failed" andNewFriendsList:nil];        
    }else if([action isEqualToString:@"notify"]){
        [delegate didNotifyFriends:false
                        withReason:@"Connection to server failed"
                  deliveryAttempts:0
                 deliverySuccesses:0];
    }
}
- (void)cancelCurrentTask {
  [self.connection cancel];
  self.connectionIsBusy = NO;
  self.connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.connectionIsBusy = NO;
    
    self.responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *results = [self.responseString JSONValue];
    
    NSLog(@"responseString = %@",self.responseString);
    
    if([[results objectForKey:@"action"] isEqualToString:@"register"]) {
        if ([[results objectForKey:@"code"] isEqualToString:@"1"]) {
            [self.delegate registrationWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        } else {
            [self.delegate registrationWasSuccessful:true withReason:@""];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"auth"]) {
        if ([[results objectForKey:@"code"] isEqualToString:@"1"]) {
            [self.delegate authorisationWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        } else {
            [self.delegate authorisationWasSuccessful:true withReason:@""];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"login"]){
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [self updateLocalSessionKey:[results objectForKey:@"sessionKey"]];
            [self storeUserId:[results objectForKey:@"userid"]];
            [self updateIsLoggedIn:YES];
            [delegate loginWasSuccessful:true withReason:nil];
        }else{
            [delegate loginWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"getFriends"]){
        [self updateLocalSessionKey:[results objectForKey:@"sessionKey"]];
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate didDownloadFriendsList:true withReason:nil andFriends:[results objectForKey:@"friends"]];
        }else{
            [delegate didDownloadFriendsList:false withReason:[results objectForKey:@"reason"] andFriends:nil];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"addFriend"]){
        [self updateLocalSessionKey:[results objectForKey:@"sessionKey"]];
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate didAddFriend:true withReason:nil andNewFriendsList:[results objectForKey:@"friends"]];        
        }else{
            [delegate didAddFriend:false withReason:[results objectForKey:@"reason"] andNewFriendsList:nil];        
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"delFriend"]){
        [self updateLocalSessionKey:[results objectForKey:@"sessionKey"]];
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate didDeleteFriend:true withReason:nil andNewFriendsList:[results objectForKey:@"friends"]];        
        }else{
            [delegate didDeleteFriend:false withReason:[results objectForKey:@"reason"] andNewFriendsList:nil];        
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"acceptFriend"]){
        [self updateLocalSessionKey:[results objectForKey:@"sessionKey"]];
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate didAcceptFriend:true withReason:nil andNewFriendsList:[results objectForKey:@"friends"]];        
        }else{
            [delegate didAcceptFriend:false withReason:[results objectForKey:@"reason"] andNewFriendsList:nil];        
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"notify"]){
        [self updateLocalSessionKey:[results objectForKey:@"sessionKey"]];
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate didNotifyFriends:true
                            withReason:nil
                      deliveryAttempts:[[results objectForKey:@"attemptedDeliveries"] intValue]
                     deliverySuccesses:[[results objectForKey:@"successfulDeliveries"] intValue]];        
        }else{
            [delegate didNotifyFriends:false
                            withReason:[results objectForKey:@"reason"]
                      deliveryAttempts:[[results objectForKey:@"attemptedDeliveries"] intValue]
                     deliverySuccesses:[[results objectForKey:@"successfulDeliveries"] intValue]];      
        }
    }
}

@end
