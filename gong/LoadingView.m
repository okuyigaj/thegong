//
//  LoadingView.m
//  gong
//
//  Created by Matthew Young on 09/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

@synthesize view, cancelButton, label, delegate, loadingMessage;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
      [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
      [self prepareView];
    }
    return self;
}


- (void) awakeFromNib
{
  [super awakeFromNib];
  [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
  [self prepareView];
  [self addSubview:self.view];
}

- (void)prepareView {
    self.opaque = NO;
    self.hidden = YES;
    self.alpha = 0.0f;
}

- (IBAction)CancelButtonPressed {
  if ([delegate respondsToSelector:@selector(LoadingViewCancelButtonWasPressed)]) {
    [delegate LoadingViewCancelButtonWasPressed];
  } else {
    NSLog(@"Delegate hasn't implemented cancel button!");
  }
}

- (void)setLoadingMessage:(NSString *)loadingMessage {
  self.label.text = loadingMessage;
}

- (void)showAnimated:(BOOL)animated {
  if (animated) {
    self.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [UIView animateWithDuration:0.5f animations:^{self.alpha=0.8f;} completion:^(BOOL b){}];
  } else {
    self.hidden = NO;
    self.alpha = 0.8f;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
  }
}

- (void)hideAnimated:(BOOL)animated {
  if (animated) {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:0.5f animations:^{self.alpha=0.0f;} completion:^(BOOL b){self.hidden = YES;}];
  } else {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    self.hidden = YES;
    self.alpha = 0.0f;
  }
}

@end
