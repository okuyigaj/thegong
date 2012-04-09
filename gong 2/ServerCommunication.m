//
//  ServerCommunication.m
//  gong
//
//  Created by James Penney1 on 08/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerCommunication.h"
#import "JSON.h"

@implementation ServerCommunication

@synthesize username;
@synthesize emailAddress;
@synthesize password;
@synthesize responseData;
@synthesize request;
@synthesize responseString;
@synthesize siteURL;
@synthesize delegate;
@synthesize action;

-(id)init{
    self.username = [NSString alloc];
    self.password = [NSString alloc];
    self.emailAddress = [NSString alloc];
    self.responseString = [NSString alloc];
    connectionIsBusy = false;
    self.action = @"nothing";
    siteURL = @"http://www.immunis.co.uk/gong/";
    
	return self;
}

-(void)updateLocalSessionKey:(NSString *)newKey andUserId:(NSString *)userId{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:newKey forKey:@"sessionKey"];
    [userDefaults setObject:userId forKey:@"userId"];
    [userDefaults synchronize];
}

-(void)registerWithUsername:(NSString *)_username email:(NSString *)_email andPassword:(NSString *)_password{
    if(connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    connectionIsBusy = true;
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
    NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)authoriseWithAuthToken:(NSString *)token forEmail:(NSString *)email{
    if(connectionIsBusy){
        [delegate authorisationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    
    self.action = @"auth";
    connectionIsBusy = true;
        
    NSString *post = [NSString stringWithFormat:@"action=auth&email=%@&authToken=%@",
                      email, token];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)loginWithEmailAddress:(NSString *)_email andPassword:(NSString *)_password{
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
    NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

-(void)getFriendsList{
    if(connectionIsBusy){
        [delegate registrationWasSuccessful:false withReason:@"Connection is busy"];
        return;
    }
    connectionIsBusy = true;
    self.action = @"getFriends";
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionKey"];
    
    NSString *post = [NSString stringWithFormat:@"action=getFriends&userid=%@&sessionKey=%@",
                      userId,
                      sessionKey,
                      deviceToken];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
    [postRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@action.php",siteURL]]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [postRequest setHTTPBody:postData];
    
    [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
	[responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [responseData release];
    connectionIsBusy = false;
    
    if([action isEqualToString:@"register"]){
        [delegate registrationWasSuccessful:false withReason:@"Connection to server failed"];
    }else if([action isEqualToString:@"auth"]){
        [delegate authorisationWasSuccessful:false withReason:@"Connection to server failed"];        
    }else if([action isEqualToString:@"login"]){
        [delegate loginWasSuccessful:false withReason:@"Connection to server failed"];        
    }else if([action isEqualToString:@"getFriends"]){
        [delegate didDownloadFriendsList:false withReason:@"Connection to server failed" andFriends:nil];        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    connectionIsBusy = false;
    
    responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [responseData release];
    
    NSDictionary *results = [NSDictionary alloc];
    results = [responseString JSONValue];
    NSLog(@"responseString = %@",responseString);
    [responseString release];
    
    if([[results objectForKey:@"action"] isEqualToString:@"register"]){
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate registrationWasSuccessful:true withReason:@""];
        }else{
            [delegate registrationWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"auth"]){
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [delegate authorisationWasSuccessful:true withReason:@""];
        }else{
            [delegate authorisationWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"login"]){
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [self updateLocalSessionKey:[results objectForKey:@"sessionKey"] andUserId:[results objectForKey:@"sessionKey"]];
            [delegate loginWasSuccessful:true withReason:@""];
        }else{
            [delegate loginWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"getFriends"]){
        if ([[results objectForKey:@"code"] isEqualToString:@"0"]){
            [self updateLocalSessionKey:[results objectForKey:@"sessionKey"] andUserId:[results objectForKey:@"userid"]];
            [delegate didDownloadFriendsList:true withReason:@"" andFriends:[results objectForKey:@"friends"]];
        }else{
            [delegate didDownloadFriendsList:false withReason:[results objectForKey:@"reason"] andFriends:nil];
        }
    }

}

-(void)dealloc{
    [username release];
    username = nil;
    [emailAddress release];
    emailAddress = nil;
    [password release];
    password = nil;
    [responseData release];
    responseData = nil;
    [request release];
    request = nil;
    [responseString release];
    responseString = nil;
    [siteURL release];
    siteURL = nil;
    
    [super dealloc];
}

@end
