//
//  InstitutionTableViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/14/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "InstitutionTableViewController.h"
#import "Datasource.h"

@interface InstitutionTableViewController ()

@property (strong, nonatomic) NSArray *availableInstitutions;

//Used to track whether we are selecting a tracking bank account or funding bank account.
@property (assign, nonatomic) BOOL trackingViewController;

@end

@implementation InstitutionTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.trackingViewController = [Datasource sharedInstance].showTrackingAccountController; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 40)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    
    /* Section header is in 0th index... */
    if (self.trackingViewController) {
        label.text = @"Select an institution to track expenses";
        
    } else {
        label.text = @"Select an institution to fund donations";
    }
    
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
    return [Datasource sharedInstance].availableInstitutions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"institutionCell" forIndexPath:indexPath];
    
    if ([Datasource sharedInstance].availableInstitutions.count > 1) {
        cell.textLabel.text = [Datasource sharedInstance].availableInstitutions[indexPath.row][@"name"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Datasource sharedInstance].selectedBankType = [Datasource sharedInstance].availableInstitutions[indexPath.row][@"type"];
    [self performSegueWithIdentifier:@"goFromInstitutionToBankLoginPage" sender:self]; 
}

@end
