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
@interface SignInViewController : ApplicationViewController <UITextFieldDelegate>
@property (nonatomic) BOOL setTheBackButton;
@property (nonatomic, weak) id<SignInDelegate> delegate;

@end
