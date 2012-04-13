//
//  ServerCommunication.h
//  gong
//
//  Created by Matthew Young on 08/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ServerCommunicationDelegate <NSObject>

@optional
- (void)registrationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason;
- (void)authorisationWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason;
- (void)loginWasSuccessful:(BOOL)_trueOrFalse withReason:(NSString *)_reason;
- (void)didDownloadFriendsList:(BOOL)_trueOrFalse withReason:(NSString *)_reason andFriends:(NSArray *)_friends;
- (void)didAddFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends;
- (void)didDeleteFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends;
- (void)didAcceptFriend:(BOOL)_trueOrFalse withReason:(NSString *)_reason andNewFriendsList:(NSArray *)_friends;
- (void)didNotifyFriends:(BOOL)_trueOrFalse withReason:(NSString *)_reason deliveryAttempts:(int)_attempts deliverySuccesses:(int)_successes;

@end

@interface ServerCommunication : NSObject<NSURLConnectionDelegate>

@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *emailAddress;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSMutableData *responseData;
@property(nonatomic, retain) NSURLRequest *request;
@property(nonatomic, retain) NSString *responseString;
@property(nonatomic, retain) NSString *siteURL;
@property(nonatomic, retain) NSString *action;
@property(nonatomic, assign) BOOL connectionIsBusy;
@property(nonatomic, assign) id <ServerCommunicationDelegate> delegate;
@property(nonatomic, retain) NSURLConnection *connection;

- (void)registerWithUsername:(NSString *)_username email:(NSString *)_email andPassword:(NSString *)_password;
- (void)authoriseWithAuthToken:(NSString *)token forEmail:(NSString *)email;
- (void)loginWithEmailAddress:(NSString *)_email andPassword:(NSString *)_password;
- (void)getFriendsList;
- (void)addFriendWithEmailAddress:(NSString *)_email;
- (void)cancelCurrentTask;
- (void)deleteFriendWithFriendshipId:(NSString *)friendship_id;
- (void)acceptFriendWithFriendshipId:(NSString *)friendship_id;
- (void)sendNotificationWithMessage:(NSString *)msg badge:(NSString *)_badge andSound:(NSString *)_sound;


@end