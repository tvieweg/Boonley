//
//  ChangeDoneeTableViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 10/17/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import "ChangeDoneeTableViewController.h"
#import "CharitySettingsViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>
#import "BackgroundLayer.h"
#import <ZFCheckbox/ZFCheckbox.h>

@interface ChangeDoneeTableViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ChangeDoneeTableViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];
        
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changeDoneeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [Datasource sharedInstance].availableDonees[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%% approval rating", [Datasource sharedInstance].availableDoneeRatings[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Save data locally.
    [Datasource sharedInstance].userCharitySelection = [Datasource sharedInstance].availableDonees[indexPath.row];
    
    //Changes have been made.
    [_activityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //Add data to parse (this will get saved at end of signup.
        PFUser *currentuser = [PFUser currentUser];
        currentuser[@"selectedDonee"] = [Datasource sharedInstance].availableDonees[indexPath.row];
        
        [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [_activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            if (succeeded) {
                
                [Datasource sharedInstance].minDonation = currentuser[@"minDonation"];
                [Datasource sharedInstance].maxDonation = currentuser[@"maxDonation"];
                
                ZFCheckbox *checkbox = [[ZFCheckbox alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
                checkbox.center = self.view.center;
                checkbox.backgroundColor = [UIColor grayColor];
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
                    [self popToCharitySettingsViewController];
                });
                
                
                
            } else {
                //show user error
                NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                
                [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
            }
        }];
    });

}

- (void)popToCharitySettingsViewController {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[CharitySettingsViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}



@end
