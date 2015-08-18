//
//  DoneeSelectionTableViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/14/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "DoneeSelectionTableViewController.h"
#import "Datasource.h"

@interface DoneeSelectionTableViewController ()

@end

@implementation DoneeSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Datasource sharedInstance].userCharitySelection = [Datasource sharedInstance].availableDonees[indexPath.row];
    [Datasource sharedInstance].showTrackingAccountController = YES;
    [self performSegueWithIdentifier:@"goToLinkFromDonees" sender:self];
}

@end
