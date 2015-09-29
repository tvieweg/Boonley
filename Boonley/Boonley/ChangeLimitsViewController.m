//
//  ChangeLimitsViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 9/15/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "ChangeLimitsViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>

@interface ChangeLimitsViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *minimumDonation;
@property (weak, nonatomic) IBOutlet UITextField *maximumDonation;

@end

@implementation ChangeLimitsViewController

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
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDone)];
    _minimumDonation.text = [[Datasource sharedInstance].minDonation stringValue];
    _maximumDonation.text = [[Datasource sharedInstance].maxDonation stringValue]; 
}

- (void) didPressDone {
    if ([self.minimumDonation.text integerValue] >= 5 && [self.maximumDonation.text integerValue] > [self.minimumDonation.text integerValue]) {
        
        //Changes have been made.
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentuser = [PFUser currentUser];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            currentuser[@"minDonation"] = [numberFormatter numberFromString:self.minimumDonation.text];
            currentuser[@"maxDonation"] = [numberFormatter numberFromString:self.maximumDonation.text];
            
            [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (succeeded) {
                    
                    [Datasource sharedInstance].minDonation = currentuser[@"minDonation"];
                    [Datasource sharedInstance].maxDonation = currentuser[@"maxDonation"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                     
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    
                    [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                }
            }];
        });
        
    } else {
        [self displayErrorAlertWithTitle:@"Error" andError:@"Miminum and maximums not set correctly. Please review your minimum and maximums"];
    }
}


@end
