//
//  MainViewController.h
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
  int _isLoggedIn;
}


@property (nonatomic, assign) BOOL isLoggedIn;

@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) IBOutlet UIButton *friendsButton;
@property (nonatomic, retain) IBOutlet UIButton *gongButton;

@end
