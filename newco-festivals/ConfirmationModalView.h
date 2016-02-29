//
//  ConfirmationModalView.h
//  newco-festivals
//
//  Created by Yaseen Anss on 2/26/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "BaseModal.h"
@protocol ConfirmationModalDelegate;

@interface ConfirmationModalView : BaseModal
- (id)initWithFrame:(CGRect)frame imageUrl:(NSString *)modalImageUrl title:(NSMutableAttributedString *)modalTitle yesText:(NSString*)yesText noText:(NSString*)noText imageColor:(UIColor*)imageColor swapCompanyColor:(UIColor*)conflictingColor;
@property (nonatomic, weak) id<ConfirmationModalDelegate> confirmationModalDelegate;
@property (nonatomic, strong) UIView *modalImageContainer;
@end

@protocol ConfirmationModalDelegate <NSObject>;

@optional
-(void)yesButtonClicked:(ConfirmationModalView*)modal;
-(void)noButtonClicked:(ConfirmationModalView*)modal;;
@end