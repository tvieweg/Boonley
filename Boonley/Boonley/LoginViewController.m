//
//  LoginViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/13/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>
#import "LoginViewController.h"
#import "Datasource.h"
#import "Plaid.h"

@interface LoginViewController () <UIAlertViewDelegate>

//boolean to determine view controller settings for signup or login.
@property (nonatomic, assign) BOOL signupActive;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator; 

@property (weak, nonatomic) IBOutlet UILabel *instructions;
@property (weak, nonatomic) IBOutlet UILabel *loginToggleLabel;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)twitterLoginPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *signupButton;
- (IBAction)signUp:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginToggleButton;
- (IBAction)toggleLoginOrSignup:(id)sender;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _password.text = @"";

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES]; 
    if ([PFUser currentUser] != nil) {
        NSLog(@"User is already logged in!");
        [self performSegueWithIdentifier:@"goFromLoginToDoneeSelection" sender:self];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];
    
    _password.secureTextEntry = YES; 
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES; 
    
    _signupActive = YES;
    
}


#pragma mark - helper methods

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                             message:errorString
                                             delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles: nil];
    [alert show];
}

#pragma mark - IBAction methods 

//helper function to set labels/button titles based on whether user is signing up or logging in.
- (IBAction)toggleLoginOrSignup:(id)sender {
    
    if (_signupActive) {
        _signupActive = NO;
        _instructions.text = @"Log In:";
        [_signupButton setTitle:@"Log in" forState:UIControlStateNormal];
        _loginToggleLabel.text = @"First time here?";
        [_loginToggleButton setTitle:@"Sign up" forState:UIControlStateNormal];
    } else {
        _signupActive = YES;
        _instructions.text = @"Sign up:";
        [_signupButton setTitle:@"Sign up!" forState:UIControlStateNormal];
        _loginToggleLabel.text = @"Already registered?";
        [_loginToggleButton setTitle:@"Login" forState:UIControlStateNormal];

    }
}

#pragma mark - signup and login

- (IBAction)signUp:(id)sender {
    
    NSString *error = @"";
    
    //Checks for valid info for login/signup and displays alert to user.
    
    if ([_username.text isEqualToString:@""] || [_password.text isEqualToString:@""]) {
        
        error = @"Please enter a username and password";
    
    }
    
    if (_signupActive == true) {
        if ([_username.text length] < 4) {
            error = @"Username must be at least 4 characters long";
        } else if ([_password.text length] < 8) {
            error = @"Password must be at least 8 characters long";
        }
    }
    
    if (![error isEqualToString:@""]) {
        [self displayErrorAlertWithTitle:@"Whoops!" andError:error];
    } else {
        //Data is valid. Send to Parse. Show activity spinner while running.

        //Start progress spinner
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        //if user is on signup page
        if (_signupActive) {
            
            //assign PF object and information to the fields.
            PFUser *user = [[PFUser alloc] init];
            user.username = _username.text;
            user.password = _password.text;
            
            //begin signup
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                //stop progress spinner
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (!error) {
                    
                    NSLog(@"Signed up!");
                    
                    [self performSegueWithIdentifier:@"goFromLoginToDoneeSelection" sender:self];

                    //[self performSegueWithIdentifier:@"goToConversationView" sender:self];
                    //TODO Go to next bank signup sheet.
                    
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    
                    [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                }
            }];
            
        //user is on login page.
        } else {
            
            //stop progress spinner
            [_activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [PFUser logInWithUsernameInBackground:_username.text password:_password.text
                                            block:^(PFUser *user, NSError *error) {
                if (user) {
                    
                    NSLog(@"Logged in!");
                    //[[Datasource sharedInstance] getUserIDandProfilePicture];
                    //[[Datasource sharedInstance] getStoredConversations];
                    [self performSegueWithIdentifier:@"goToAccountOverviewFromLogin" sender:self];

                    //[self performSegueWithIdentifier:@"goToConversationView" sender:self];
                    //TODO: Go to account overviews, user has already signed up.
                    //TODO: Will need to be able to handle check for all relevant information at Account Overview page.
                    
                } else {
                    if ([error userInfo][@"error"]) {
                        NSString *errorString = [error userInfo][@"error"];
                        
                        [self displayErrorAlertWithTitle:@"Login failed" andError:errorString];
                    }
                }
            }];
        }
    }
}

- (IBAction)facebookButtonPressed:(id)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self performSegueWithIdentifier:@"goFromLoginToDoneeSelection" sender:self];

        } else {
            NSLog(@"User logged in through Facebook!");
            [self performSegueWithIdentifier:@"goToAccountOverviewFromLogin" sender:self];


        }
    }];
}

- (IBAction)twitterLoginPressed:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self performSegueWithIdentifier:@"goFromLoginToDoneeSelection" sender:self];


        } else {
            NSLog(@"User logged in with Twitter!");
            [self performSegueWithIdentifier:@"goToAccountOverviewFromLogin" sender:self];

        }
    }];
}
@end
