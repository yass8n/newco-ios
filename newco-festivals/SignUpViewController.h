//
//  SignUpViewController.h
//  now-sessions
//
//  Created by Yaseen Anss on 3/11/16.
//  Copyright © 2016 now. All rights reserved.
//

#import "ApplicationViewController.h"
#import "SignUpViewController.h"

@protocol SignUpDelegate <NSObject>
@optional
-(void)goBackFromSignUp;
@end
@interface SignUpViewController : ApplicationViewController <UITextFieldDelegate>

@property (nonatomic) BOOL setTheBackButton;
@property (nonatomic, weak) id<SignUpDelegate> delegate;

@end