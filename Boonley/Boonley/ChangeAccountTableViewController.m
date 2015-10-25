//
//  ChangeAccountTableViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 9/15/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "ChangeAccountTableViewController.h"
#import "BankAccountSettingsViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>
#import <ZFCheckbox/ZFCheckbox.h>

@interface ChangeAccountTableViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ChangeAccountTableViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect cell
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //If user just picked tracking bank, ask if they want to use this same bank or different bank to fund the donations.
    if ([Datasource sharedInstance].showTrackingAccountController) {
        
        PFUser *currentuser = [PFUser currentUser];
        currentuser[@"accountIDForTracking"] = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row][@"_id"];
        
        [Datasource sharedInstance].bankForTracking.selectedAccount = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row];
        [self saveToParse];
        
    } else {
        
        PFUser *currentuser = [PFUser currentUser];
        currentuser[@"accountIDForFunding"] = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row][@"_id"];
        
        [Datasource sharedInstance].bankForFunding.selectedAccount = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row];
        [self popToAccountSettingsViewController];
        
    }
}

- (void)saveToParse {
    
    //Changes made. Save to Parse. 
    [_activityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PFUser *currentuser = [PFUser currentUser]; 
        
        [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [_activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            if (succeeded) {
                
                ZFCheckbox *checkbox = [[ZFCheckbox alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
                checkbox.center = self.view.center;
                checkbox.backgroundColor = [UIColor clearColor];
                checkbox.lineColor = [UIColor grayColor]; 
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
                    [self popToAccountSettingsViewController];
                });
            } else {
                //show user error
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                
                [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
            }
        }];
    });

    
}

- (void)popToAccountSettingsViewController {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[BankAccountSettingsViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

@end
