//
//  SignUpViewController.h
//  newco-festivals
//
//  Created by Yaseen Anss on 3/11/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "ApplicationViewController.h"
@protocol SignUpDelegate <NSObject>
@optional
-(void)goBack;
@end
@interface SignUpViewController : ApplicationViewController <UITextFieldDelegate>

@property (nonatomic) BOOL setTheBackButton;
@property (nonatomic, weak) id<SignUpDelegate> delegate;

@end