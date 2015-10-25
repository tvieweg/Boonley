//
//  ChangePasswordViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 9/15/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>
#import <ZFCheckbox/ZFCheckbox.h>
#import "BackgroundLayer.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *changedPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPasswordTextField;

@end

@implementation ChangePasswordViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDone)];
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];

}

- (void)didPressDone {
    //if passwords match and meet criteria, save to parse and return to main screen.
    if ([_changedPasswordTextField.text isEqualToString:_confirmedPasswordTextField.text]) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentUser = [PFUser currentUser];
            currentUser.password = _confirmedPasswordTextField.text;
            
            [_activityIndicator startAnimating];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (succeeded) {
                    
                    ZFCheckbox *checkbox = [[ZFCheckbox alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
                    checkbox.center = self.view.center;
                    checkbox.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:checkbox];
                    [checkbox setSelected:NO animated:NO];
                    checkbox.animateDuration = 0.5;
                    
                    double delayInSeconds = 0.05;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [checkbox setSelected:YES animated:YES];
                    });
                    
                    delayInSeconds = 1.0;
                    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    
                    [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                }
            }];
        });
        
    } else {
        [self displayErrorAlertWithTitle:@"Error" andError:@"Passwords don't match! Please check them."];
    }

    
}

@end
