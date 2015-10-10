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

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *changedPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPasswordTextField;

@end

@implementation ChangePasswordViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:errorString
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDone)];
    
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
                    [self.navigationController popViewControllerAnimated:YES];
                    
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
