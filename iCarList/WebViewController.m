//
//  WebViewController.m
//  iCarList
//
//  Created by Eric Labaci on 6/26/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithSearchString:(NSString *)searchString {
    self = [super initWithNibName:nil bundle:nil];
    
    stringURL = searchString;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *URL;
    if (stringURL.length == 0) {
        URL = [NSURL URLWithString:@"https://images.google.com/"];
    } else {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/search?tbm=isch&q=%@", stringURL]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.barButtonGetURL.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activity startAnimating];
    self.barButtonGetURL.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activity stopAnimating];
    self.barButtonGetURL.enabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getURL:(id)sender {
    if (![self.delegate getStringURL:self.webView.request.URL.absoluteString]) {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"Error" message:@"The URL does not refer to an image." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
        [alertError addAction:actionOK];
        [self presentViewController:alertError animated:YES completion:nil];
    } else {
        UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Success" message:@"The image was added to the gallery. Do you want to download more images?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *act) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [successAlert addAction:actionContinue];
        [successAlert addAction:actionCancel];
        [self presentViewController:successAlert animated:YES completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
