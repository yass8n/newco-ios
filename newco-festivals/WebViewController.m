//
//  WebViewController.m
//  newco-IOS
//
//  Created by alondra on 2/14/16.
//  Copyright © 2016 Newco. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)doneButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation WebViewController
- (NSString *)parseUrl:(NSString *)url {
    if (url.length == 0 || [url isEqualToString:@"http://"]) {
        return @"http://festivals.newco.co/"; // put your desired URL here
    } else if ([[url lowercaseString] hasPrefix:@"http://"] || [[url lowercaseString] hasPrefix:@"https://"]) {
        return url;
    } else {
        return [NSString stringWithFormat:@"http://%@", url];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:[self parseUrl:self.url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finish");
    [UIApplication sharedApplication].
    networkActivityIndicatorVisible = NO;
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"Error for WEBVIEW: %@", [error description]);
    [self hidePageLoader];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self hidePageLoader];
}
@end
