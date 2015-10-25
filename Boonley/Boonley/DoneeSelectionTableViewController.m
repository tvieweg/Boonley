//
//  DoneeSelectionTableViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/14/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "DoneeSelectionTableViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>
#import "BackgroundLayer.h"

@interface DoneeSelectionTableViewController ()


@end

@implementation DoneeSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];


}

#pragma mark - Table view

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 80)];
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    label.textAlignment = NSTextAlignmentCenter; 
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"Select a Charity";
        
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:192/255.0 blue:161/255.0 alpha:1.0]];
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [Datasource sharedInstance].availableDonees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [Datasource sharedInstance].availableDonees[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%% approval rating", [Datasource sharedInstance].availableDoneeRatings[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Datasource sharedInstance].showTrackingAccountController = YES;
    
    //Add data to parse (this will get saved at end of signup.
    PFUser *currentuser = [PFUser currentUser];
    currentuser[@"selectedDonee"] = [Datasource sharedInstance].availableDonees[indexPath.row];
    
    //Save data locally.
    [Datasource sharedInstance].userCharitySelection = [Datasource sharedInstance].availableDonees[indexPath.row];
    
    [self performSegueWithIdentifier:@"goToLinkFromDonees" sender:self];
    
}

@end
