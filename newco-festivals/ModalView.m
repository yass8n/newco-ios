//
//  ModalView.m
//  now-sessions
//
//  Created by alondra on 2/15/16.
//  Copyright © 2016 now. All rights reserved.
//

#import "ModalView.h"
#import "Helper.h"
@implementation ModalView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSString *)modalTitle text:(NSMutableAttributedString *)modalText imageColor:(UIColor*)imageColor
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *modalContainer = [[UIView alloc] initWithFrame:self.bounds];
        UIView *modalContent = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        22,
                                                                        modalContainer.frame.size.width,
                                                                        modalContainer.frame.size.height - 22)];
        modalContent.backgroundColor = [UIColor whiteColor];
        modalContent.layer.cornerRadius = 3.0f;
        modalContent.layer.masksToBounds = YES;
        [modalContainer addSubview:modalContent];
        
        UIView *modalImageContainer = [[UIView alloc] initWithFrame:CGRectMake((modalContainer.frame.size.width - 44)/2, 0, 44, 44)];
        modalImageContainer.layer.cornerRadius = modalImageContainer.frame.size.width / 2;
        modalImageContainer.layer.masksToBounds = YES;
        modalImageContainer.backgroundColor = [UIColor whiteColor];
        [modalContainer addSubview:modalImageContainer];
        
        UIImageView *modalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
        modalImageView.image = [modalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [modalImageView setTintColor:imageColor];
        modalImageView.layer.cornerRadius = modalImageView.frame.size.width / 2;
        modalImageView.layer.masksToBounds = YES;
        [modalImageContainer addSubview:modalImageView];

    
        
        UITextView *modalTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 20, modalContent.frame.size.width - 10, 100)];
        
        modalTextView.attributedText = modalText;
        modalTextView.textAlignment = NSTextAlignmentCenter;
        [modalContent addSubview:modalTextView];
        
        
        UIButton *closeModalButton = [[UIButton alloc] initWithFrame:CGRectMake(1, modalContent.frame.size.height - 41, modalContent.frame.size.width - 2, 40)];
        closeModalButton.backgroundColor = [Helper getUIColorObjectFromHexString:@"#34495e" alpha:1.0];
        closeModalButton.titleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 16.0f];
        [closeModalButton setTitle:@"GOT IT" forState:UIControlStateNormal];
        [closeModalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeModalButton.layer.cornerRadius = 2.5f;
        closeModalButton.layer.masksToBounds = YES;
        [closeModalButton addTarget:self action:@selector(hideModal) forControlEvents:UIControlEventTouchUpInside];
        [modalContent addSubview:closeModalButton];
        
        
        [self addSubview:modalContainer];
        
    }
    return self;
}

@end