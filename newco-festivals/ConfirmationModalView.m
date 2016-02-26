//
//  ConfirmationModalView.m
//  newco-festivals
//
//  Created by Yaseen Anss on 2/26/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "ConfirmationModalView.h"
#import "TTTAttributedLabel.h"
@interface ConfirmationModalView()
@property (strong, nonatomic) TTTAttributedLabel* modalTitleLabel;
@property (strong, nonatomic) UIView* modalContent;
@property (strong, nonatomic) UIButton* closeModalButton;
@end
@implementation ConfirmationModalView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)modalImage title:(NSMutableAttributedString *)modalTitle yesBlock:(HandlingBlock)yesBlock noBlock:(HandlingBlock)noBlock{
    noBlock();
    yesBlock();
    self = [super initWithFrame:frame];
    UIView *modalContainer = [[UIView alloc] initWithFrame:self.bounds];
    
    self.modalContent = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 modalContainer.frame.size.width,
                                                                 modalContainer.frame.size.height - 22)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    self.YTapThreshhold = screenHeight; //if they tap anywhere out of the modal it will disappear
    
    self.modalContent.backgroundColor = [UIColor whiteColor];
    self.modalContent.layer.cornerRadius = 3.0f;
    self.modalContent.layer.masksToBounds = YES;
    [modalContainer addSubview:self.modalContent];
    
    
    //adding "list create" image at top center
    UIView *modalImageContainer = [[UIView alloc] initWithFrame:CGRectMake((modalContainer.frame.size.width - 44)/2, -22, 44, 44)];
    modalImageContainer.layer.cornerRadius = modalImageContainer.frame.size.width / 2;
    modalImageContainer.layer.masksToBounds = YES;
    modalImageContainer.backgroundColor = [UIColor whiteColor];
    [modalContainer addSubview:modalImageContainer];
    
    UIImageView *modalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
    modalImageView.image = modalImage;
    modalImageView.layer.cornerRadius = modalImageView.frame.size.width/2;
    modalImageView.layer.masksToBounds = YES;
    [modalImageContainer addSubview:modalImageView];

    //adding title
    self.modalTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 25, self.modalContent.frame.size.width, 0)];
    self.modalTitleLabel.numberOfLines = 0;
    self.modalTitleLabel.minimumFontSize = 0;
    self.modalTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.modalTitleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 18];
    self.modalTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.modalTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.modalTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.modalTitleLabel.textAlignment = NSTextAlignmentCenter;

    self.modalTitleLabel.attributedText = modalTitle;
    
    int numlines = [Helper lineCountForLabel:self.modalTitleLabel];
    CGRect labelFrame = self.modalTitleLabel.frame;
    labelFrame.size.height = numlines * 25;
    self.modalTitleLabel.frame = labelFrame;
    CGRect modalFrame = self.modalContent.frame;
    modalFrame.size.height = modalFrame.size.height + (numlines - 2) * 20;
    self.modalContent.frame = modalFrame;
    [self.modalContent addSubview:self.modalTitleLabel];
    
    
    self.closeModalButton = [[UIButton alloc] initWithFrame:CGRectMake(1, self.modalContent.frame.size.height - 41, self.modalContent.frame.size.width - 2, 40)];
    self.closeModalButton.backgroundColor = [UIColor orangeColor];
    self.closeModalButton.titleLabel.font = [UIFont fontWithName: @"ProximaNova-Semibold" size: 16.0f];
    [self.closeModalButton setTitle:@"AWESOME!" forState:UIControlStateNormal];
    [self.closeModalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeModalButton.layer.cornerRadius = 2.5f;
    self.closeModalButton.layer.masksToBounds = YES;
    [self.closeModalButton addTarget:self.baseModalDelegate action:@selector(hideModal:) forControlEvents:UIControlEventTouchUpInside];
    [self.modalContent addSubview:self.closeModalButton];
    
    [self addSubview:modalContainer];
    
return self;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
