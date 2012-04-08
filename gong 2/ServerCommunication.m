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
        if ([[results objectForKey:@"code"] isEqualToString:@"1"]){
            [delegate registrationWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        }else{
            [delegate registrationWasSuccessful:true withReason:@""];
        }
    }else if([[results objectForKey:@"action"] isEqualToString:@"auth"]){
        if ([[results objectForKey:@"code"] isEqualToString:@"1"]){
            [delegate authorisationWasSuccessful:false withReason:[results objectForKey:@"reason"]];
        }else{
            [delegate authorisationWasSuccessful:true withReason:@""];
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
