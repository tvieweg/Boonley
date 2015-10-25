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
#import "BankAccountTableViewCell.h"

@interface BankAccountTableViewController () <UIAlertViewDelegate>

@end

@implementation BankAccountTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 40)];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    label.textColor = [UIColor whiteColor];
    
    /* Section header is in 0th index... */
    if ([Datasource sharedInstance].showTrackingAccountController) {
        label.text = @"Select an account for tracking";

    } else {
        label.text = @"Select an account for funding";
    }
    
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:192/255.0 blue:161/255.0 alpha:1.0]];
    return headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankAccountCell" forIndexPath:indexPath];
    
    NSDictionary *accountInfo;
    
    if ([Datasource sharedInstance].showTrackingAccountController) {
        accountInfo = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row];
    } else {
        accountInfo = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row];
    }
    
    cell.accountName.text = [[NSString stringWithFormat:@"%@ (...%@)", accountInfo[@"meta"][@"name"], accountInfo[@"meta"][@"number"]] uppercaseString];
    cell.balance.text = [NSString stringWithFormat:@"$%@", accountInfo[@"balance"][@"available"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect cell
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //If user just picked tracking bank, ask if they want to use this same bank or different bank to fund the donations.
    if ([Datasource sharedInstance].showTrackingAccountController) {
        
        PFUser *currentuser = [PFUser currentUser];
        currentuser[@"accountIDForTracking"] = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row][@"_id"];
        
        [Datasource sharedInstance].bankForTracking.selectedAccount = [Datasource sharedInstance].bankForTracking.accounts[indexPath.row];
        [Datasource sharedInstance].showTrackingAccountController = NO;
        
        //Ask user if they want to select the same bank for funding.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Need another bank?", @"Bank Option Title") message:NSLocalizedString(@"Do you want to use this bank for funding donations or choose another?", @"Funding Option Message") preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *useExistingBank = [UIAlertAction actionWithTitle:NSLocalizedString(@"Use this bank", @"Use Existing Bank Option") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"Use this bank clicked");
            //Make bank for funding equal to the tracking bank.
            
            PFUser *currentuser = [PFUser currentUser];
            currentuser[@"fundingToken"] = [Datasource sharedInstance].accessTokens[@"trackingToken"];
                [Datasource sharedInstance].bankForFunding = [Datasource sharedInstance].bankForTracking;
                //Update instructions for user in header.
                [self tableView:self.tableView viewForHeaderInSection:0];
                
                //TODO: Only show accounts (no credit cards used for funding.)
                [self.tableView reloadData];
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
        
        PFUser *currentuser = [PFUser currentUser];
        currentuser[@"accountIDForFunding"] = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row][@"_id"];
        
        [Datasource sharedInstance].bankForFunding.selectedAccount = [Datasource sharedInstance].bankForFunding.accounts[indexPath.row];
        
        [self performSegueWithIdentifier:@"goToThresholdSelectionFromAccounts" sender:self];

        
    }
}

@end
