//
//  ConfirmationModalView.h
//  newco-festivals
//
//  Created by Yaseen Anss on 2/26/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "BaseModal.h"
@protocol ConfirmationModalDelegate <NSObject>;

@optional
-(void)yesButtonClicked;
-(void)noButtonClicked;
@end

@interface ConfirmationModalView : BaseModal
- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSMutableAttributedString *)modalTitle yesText:(NSString*)yesText noText:(NSString*)noText imageColor:(UIColor*)imageColor;
@property (nonatomic, weak) id<ConfirmationModalDelegate> confirmationModalDelegate;
@end
