//
//  SignInViewController.h
//  newco-IOS
//
//  Created by Yassen Aniss
//  Copyright (c) 2016 Newco. All rights reserved.
//
@protocol SignInDelegate <NSObject>

@optional
-(void)goBack;
@end

#import "SignUpViewController.h"

@interface SignInViewController : ApplicationViewController <UITextFieldDelegate, SignUpDelegate>
@property (nonatomic) BOOL setTheBackButton;
@property (nonatomic, weak) id<SignInDelegate> delegate;

@end
