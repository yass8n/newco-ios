//
//  ConfirmationModalView.h
//  newco-festivals
//
//  Created by Yaseen Anss on 2/26/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "BaseModal.h"
#import "TTTAttributedLabel.h"
@protocol ConfirmationModalDelegate;

@interface ConfirmationModalView : BaseModal <TTTAttributedLabelDelegate>
- (id)initWithFrame:(CGRect)frame title:(NSMutableAttributedString *)modalTitle yesText:(NSString*)yesText noText:(NSString*)noText imageColor:(UIColor*)imageColor conflictingSession:(Session*)conflictingSession;
@property (nonatomic, weak) id<ConfirmationModalDelegate> confirmationModalDelegate;
@property (nonatomic, strong) UIView *modalImageContainer;
@end

@protocol ConfirmationModalDelegate <NSObject>;
@optional
-(void)linkTapped:(TTTAttributedLabel*)label modal:(ConfirmationModalView*)modal;
@required
-(void)yesButtonClicked:(ConfirmationModalView*)modal;
-(void)noButtonClicked:(ConfirmationModalView*)modal;;
@end
