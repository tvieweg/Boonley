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

@interface DoneeSelectionTableViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation DoneeSelectionTableViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];
    
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
    [Datasource sharedInstance].showTrackingAccountController = YES;
    
    //Start progress spinner
    [_activityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PFUser *currentuser = [PFUser currentUser];
        currentuser[@"selectedDonee"] = [Datasource sharedInstance].availableDonees[indexPath.row];
        [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [_activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            if (succeeded) {
                
                [Datasource sharedInstance].userCharitySelection = [Datasource sharedInstance].availableDonees[indexPath.row];
                [self performSegueWithIdentifier:@"goToLinkFromDonees" sender:self];
            } else {
                //show user error
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                
                [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
            }
        }];
    });

    
}

@end
