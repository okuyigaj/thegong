//
//  ViewController.h
//  gong
//
//  Created by James Penney1 on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommunication.h"

@interface ViewController : UIViewController <ServerCommunicationDelegate>{
    IBOutlet UILabel *lblDeviceToken;
    IBOutlet UITextField *txtAuthToken;
    ServerCommunication *sc;
}

@property (nonatomic, retain) IBOutlet UILabel *lblDeviceToken;
@property (nonatomic, retain) IBOutlet UITextField *txtAuthToken;
@property (nonatomic, retain) ServerCommunication *sc;

-(IBAction)registerDevice;
-(IBAction)tryRegistration;

@end
