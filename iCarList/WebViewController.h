//
//  WebViewController.h
//  iCarList
//
//  Created by Eric Labaci on 6/26/17.
//  Copyright © 2017 Eric Labaci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewControllerDelegate <NSObject>

- (BOOL)getStringURL:(NSString *)stringURL;

@end

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    NSString *stringURL;
}

@property (weak, nonatomic) id <WebViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonGetURL;

- (id)initWithSearchString:(NSString *)searchString;

- (IBAction)getURL:(id)sender;
- (IBAction)dismissViewController:(id)sender;

@end
