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
    }
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
    }

}

@end
