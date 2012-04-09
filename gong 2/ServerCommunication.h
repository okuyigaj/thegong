//
//  ServerCommunication.h
//  gong
//
//  Created by James Penney1 on 08/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerCommunicationDelegate <NSObject>

@optional
-(void)registrationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason;
-(void)authorisationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason;
-(void)loginWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason;
-(void)didDownloadFriendsList:(BOOL)_trueOrFalse withReason:(NSString *)_reason andFriends:(NSArray *)_friends;
-(void)didAddFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends;

@end


@interface ServerCommunication : NSObject <NSURLConnectionDelegate>{
    NSString *username;
    NSString *emailAddress;
    NSString *password;
    NSMutableData *responseData;
    NSURLRequest *request;
	NSString *responseString;
    NSString *siteURL;
    NSString *action;
    
    BOOL connectionIsBusy;
    
    __weak id <ServerCommunicationDelegate> delegate;
}

@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *emailAddress;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) NSURLRequest *request;
@property(nonatomic, retain) NSString *responseString;
@property(nonatomic, retain) NSString *siteURL;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, assign) __weak id <ServerCommunicationDelegate> delegate;

-(void)registerWithUsername:(NSString *)_username email:(NSString *)_email andPassword:(NSString *)_password;
-(void)authoriseWithAuthToken:(NSString *)token forEmail:(NSString *)email;
-(void)loginWithEmailAddress:(NSString *)_email andPassword:(NSString *)_password;
-(void)getFriendsList;
-(void)addFriendWithEmailAddress:(NSString *)_email;


@end
