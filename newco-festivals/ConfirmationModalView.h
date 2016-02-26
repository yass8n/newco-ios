//
//  ConfirmationModalView.h
//  newco-festivals
//
//  Created by Yaseen Anss on 2/26/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "BaseModal.h"
typedef void (^HandlingBlock)();

@interface ConfirmationModalView : BaseModal
- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSMutableAttributedString *)modalTitle yesBlock:(HandlingBlock)yesBlock noBlock:(HandlingBlock)noBlock;
@end
