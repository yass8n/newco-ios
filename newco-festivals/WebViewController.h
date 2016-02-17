//
//  WebViewController.h
//  newco-IOS
//
//  Created by alondra on 2/14/16.
//  Copyright © 2016 yassen aniss. All rights reserved.
//

#import "ApplicationViewController.h"

@interface WebViewController : ApplicationViewController <UIWebViewDelegate>
@property (nonatomic, strong) NSString* url;
@end
