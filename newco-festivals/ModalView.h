//
//  ModalView.h
//  now-sessions
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 now. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIView.h"
#import "BaseModal.h"

@interface ModalView : BaseModal <TargetViewDelegate>

- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSString *)modalTitle text:(NSMutableAttributedString *)modalText imageColor:(UIColor*)imageColor;

@end