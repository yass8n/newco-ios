//
//  EditProfileViewController.h
//  now-sessions
//
//  Created by Yaseen Anss on 2/28/16.
//  Copyright © 2016 now. All rights reserved.
//

#import "ApplicationViewController.h"

@interface EditProfileViewController : ApplicationViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) BOOL dontSetBackButton;

@end
