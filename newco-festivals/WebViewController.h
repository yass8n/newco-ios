//
//  WebViewController.h
//  now-sessions
//
//  Created by alondra on 2/14/16.
//  Copyright © 2016 now. All rights reserved.
//

#import "ApplicationViewController.h"

@interface WebViewController : ApplicationViewController <UIWebViewDelegate>
@property (nonatomic, strong) NSString* url;
@end
