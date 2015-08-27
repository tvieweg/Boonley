//
//  BankAccountTableViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/16/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "BankAccountTableViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>

@interface BankAccountTableViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation BankAccountTableViewController

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
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [Datasource sharedInstance].bankForTracking.accounts.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 40)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    
    /* Section header is in 0th index... */
    if ([Datasource sharedInstance].showTrackingAccountController) {
        label.text = @"Select an account to track expenses";

    } else {
        label.text = @"Select an account to fund donations";
    }
    
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:192/255.0 blue:161/255.0 alpha:1.0]];
    return headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankAccountCell" forIndexPath:indexPath];
    
    NSDictionary *accountInfo = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row];
    
    cell.textLabel.text = accountInfo[@"meta"][@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Available: $%@", accountInfo[@"balance"][@"available"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect cell
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //If user just picked tracking bank, ask if they want to use this same bank or different bank to fund the donations.
    if ([Datasource sharedInstance].showTrackingAccountController) {
        
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentuser = [PFUser currentUser];
            currentuser[@"accountIDForTracking"] = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row][@"_id"];
            [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (succeeded) {
                    
                    [Datasource sharedInstance].bankForTracking.selectedAccount = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row];
                    [Datasource sharedInstance].showTrackingAccountController = NO;
                    [self performSegueWithIdentifier:@"goToThresholdSelectionFromAccounts" sender:self];
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    
                    [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                }
            }];
        });

        //Ask user if they want to select the same bank for funding.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Need another bank?", @"Storage Option Title") message:NSLocalizedString(@"Do you want to use this bank for funding donations or choose another?", @"Funding Option Message") preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *useExistingBank = [UIAlertAction actionWithTitle:NSLocalizedString(@"Use this bank", @"Use Existing Bank Option") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Use this bank clicked");
            //Make bank for funding equal to the tracking bank.
            [_activityIndicator startAnimating];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                PFUser *currentuser = [PFUser currentUser];
                currentuser[@"fundingToken"] = [Datasource sharedInstance].accessTokens[@"trackingToken"];
                [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    [_activityIndicator stopAnimating];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    if (succeeded) {
                        
                        [Datasource sharedInstance].bankForFunding = [Datasource sharedInstance].bankForTracking;
                        //Update instructions for user in header.
                        [self tableView:self.tableView viewForHeaderInSection:0];
                        
                        //TODO: Only show accounts (no credit cards used for funding.)
                        [self.tableView reloadData];


                    } else {
                        //show user error
                        NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                        
                        [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                    }
                }];
            });

        }];
        
        UIAlertAction *useNewBank = [UIAlertAction actionWithTitle:NSLocalizedString(@"Choose another bank", @"Use Another Bank Option") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Use another bank clicked");
            //Go back to institution selection for selecting a funding bank.
            UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:2];
            [self.navigationController popToViewController:prevVC animated:YES];
        }];
        
        [alert addAction:useExistingBank];
        [alert addAction:useNewBank];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentuser = [PFUser currentUser];
            currentuser[@"accountIDForFunding"] = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row][@"_id"];
            [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (succeeded) {
                    
                    [Datasource sharedInstance].bankForFunding.selectedAccount = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row];
                    
                    [self performSegueWithIdentifier:@"goToThresholdSelectionFromAccounts" sender:self];
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                }
            }];
        });
    }
}



@end
