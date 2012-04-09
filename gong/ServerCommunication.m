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
@synthesize siteURL, delegate, action, connectionIsBusy, connection;

- (id)init {
  if (self = [super init]) {
    self.connectionIsBusy = NO;
    self.action = @"nothing";
    self.siteURL = @"http://www.immunis.co.uk/gong/";
  }
  return self;
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

- (void)registerWithUsername:(NSString *)_username email:(NSString *)_email andPassword:(NSString *)_password{
    if(connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    self.connectionIsBusy = YES;
    self.username = _username;
    self.emailAddress = _email;
    self.password = _password;
    self.action = @"register";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        
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
    if(connectionIsBusy){
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
    if(connectionIsBusy){
        [delegate loginWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    connectionIsBusy = true;
    self.emailAddress = _email;
    self.password = _password;
    self.action = @"login";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
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
    if(connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    connectionIsBusy = true;
    self.action = @"getFriends";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
    
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
    if(connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    connectionIsBusy = true;
    self.action = @"addFriend";
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
    
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
    }


}

@end
