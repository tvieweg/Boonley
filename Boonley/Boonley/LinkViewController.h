//
//  ViewController.h
//  Plaid Link UIWebView
//
//  Created by Paolo Bernasconi.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
