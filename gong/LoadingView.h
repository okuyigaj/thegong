//
//  LoadingView.h
//  gong
//
//  Created by Matthew Young on 09/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingViewDelegate <NSObject>

@optional
- (void)LoadingViewCancelButtonWasPressed;
@end

@interface LoadingView : UIView

@property (nonatomic, retain) IBOutlet UIView *view;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, assign) IBOutlet id <LoadingViewDelegate> delegate;
@property (nonatomic, retain) NSString *loadingMessage;

- (IBAction)CancelButtonPressed;
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
