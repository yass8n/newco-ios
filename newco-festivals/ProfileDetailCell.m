//
//  ProfileDetailCell.m
//  newco-festivals
//
//  Created by Yaseen Anss on 2/19/16.
//  Copyright © 2016 newco. All rights reserved.
//

#import "ProfileDetailCell.h"
#import "EditProfileViewController.h"
#import "ApplicationViewController.h"
@implementation ProfileDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editProfile:(id)sender {
    [Helper buttonTappedAnimation:self.editProfileButton];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileViewController *vcA  = [storyboard instantiateViewControllerWithIdentifier:@"EditProfile"];
    UIViewController *topVc = [ApplicationViewController topViewController];
    [topVc.navigationController pushViewController:vcA animated:YES];
}
@end
