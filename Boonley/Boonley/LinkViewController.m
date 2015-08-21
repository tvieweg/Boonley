//
//  ViewController.m
//  Plaid Link UIWebView
//
//  Created by Paolo Bernasconi (edited for Boonley by Trevor Vieweg).
//  Copyright (c) 2015 Plaid LLC. All rights reserved.
//

#import "LinkViewController.h"
#import "Datasource.h"
#import "Plaid.h"

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webview setDelegate: self];
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:192/255.0 blue:161/255.0 alpha:1.0];
    _webview.backgroundColor = [UIColor clearColor];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    if ([htmlFile length]) {
        
        // Get the contents of the html file
        NSError *error = NULL;
        NSString *html = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:&error];
        if ([html length]) {
            
            NSURL *baseURL = [NSURL fileURLWithPath:htmlFile];
            
            // Load the html into the web view
            [_webview loadHTMLString:html baseURL:baseURL];
            
        } // handle error here
    } // handle error here
}

#pragma mark - UIWebViewDelegate methods

// This delegate method is used to grab any links used to "talk back" to Objective-C code from the html/JavaScript
-(BOOL) webView:(UIWebView *)inWeb
        shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)type {
    
    // these need to match the values defined in your JavaScript
    NSString *linkScheme = @"linkApp";
    NSString *actionScheme = request.URL.scheme;
    NSString *actionType = request.URL.host;
    
    if ([actionScheme isEqualToString:linkScheme]) {
        NSLog(@"%@", request.URL.scheme);
    }
    
    // look at the actionType and do whatever you want here
    if ([actionType isEqualToString:@"handlePublicToken"]) {
        NSLog(@"public_token: %@", request.URL.fragment);
        // send this public_token to your server, where you can exchange it with for an access_token
        NSString *publicToken = request.URL.fragment;
        
        [Plaid getAccessTokenForPublicToken:publicToken withCompletionHandler:^(NSDictionary *output) {
            if ([Datasource sharedInstance].showTrackingAccountController) {
                NSLog(@"%d", [Datasource sharedInstance].showTrackingAccountController);
                [[Datasource sharedInstance].accessTokens setValue:output[@"access_token"] forKey:@"trackingToken"];
                [Plaid getTransactionalDataWithAccessToken:[Datasource sharedInstance].accessTokens[@"trackingToken"] WithCompletionHandler:^(NSDictionary *output) {
                    NSLog(@"%@", output);
                    [Datasource sharedInstance].bankForTracking = [[Bank alloc] initWithBankInfo:output];
                    
                    [self performSegueWithIdentifier:@"goToAccountSelectionFromLink" sender:self];
                }];

            } else {
                NSLog(@"%d", [Datasource sharedInstance].showTrackingAccountController);
                [[Datasource sharedInstance].accessTokens setValue:output[@"access_token"] forKey:@"fundingToken"];
                [Plaid getTransactionalDataWithAccessToken:[Datasource sharedInstance].accessTokens[@"fundingToken"] WithCompletionHandler:^(NSDictionary *output) {
                    NSLog(@"%@", output);
                    [Datasource sharedInstance].bankForTracking = [[Bank alloc] initWithBankInfo:output];
                    
                    [self performSegueWithIdentifier:@"goToAccountSelectionFromLink" sender:self];
                }];
            }
        }]; 
        
        [self dismissViewControllerAnimated:true completion:^(){}]; // close the WebView modal
    } else if ([actionType isEqualToString:@"closeLinkModal"]) {
        NSLog(@"closeLinkModal");
    } else if ([actionType isEqualToString:@"handleOnLoad"]) {
        NSLog(@"handleOnLoad");
    } else if ([actionType isEqualToString:@"handleOnExit"]) {
        NSLog(@"handleOnExit");
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    // handle webViewDidStartLoad
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // handle webViewDidFinishLoad
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end