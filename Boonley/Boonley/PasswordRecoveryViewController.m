//
//  PasswordRecoveryViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 10/17/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import "PasswordRecoveryViewController.h"
#import <Parse/Parse.h>
#import "BackgroundLayer.h"
#import <ZFCheckbox/ZFCheckbox.h>


@interface PasswordRecoveryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *enterEmailInstructions;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)resetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *thanksLabel;
@end

@implementation PasswordRecoveryViewController

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    _resetButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _resetButton.layer.borderWidth = 1.0;
    _resetButton.layer.cornerRadius = 5.0;


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _thanksLabel.hidden = YES;

}

- (IBAction)resetPassword:(id)sender {
    if ([self validateEmail:_email.text] != 1) {
        [self displayErrorAlertWithTitle:@"Whoops!" andError:@"Are you sure this is a valid email? Doesn't look like it to us."];
    } else {
        [PFUser requestPasswordResetForEmailInBackground:_email.text];
        
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
            _thanksLabel.hidden = NO;
        });
        
        delayInSeconds = 3.0;
        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });

    }
}

- (void) didPressDone {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - helper methods

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
