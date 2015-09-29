//
//  BankAccountSettingsViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 9/14/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "BankAccountSettingsViewController.h"
#import "Datasource.h"

@interface BankAccountSettingsViewController ()

@property (nonatomic, strong) UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UILabel *trackingAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *trackingAccountButton;
- (IBAction)changeTrackingAccount:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *fundingAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *fundingAccountButton;
- (IBAction)changeFundingAccount:(id)sender;

@end

@implementation BankAccountSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Account Settings";
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    [self.view addSubview:self.navBar];
    [self.navBar pushNavigationItem:self.navigationItem animated:NO];
    
    _trackingAccountButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _trackingAccountButton.layer.borderWidth = 1.0;
    _trackingAccountButton.layer.cornerRadius = 5.0;
    
    _fundingAccountButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _fundingAccountButton.layer.borderWidth = 1.0;
    _fundingAccountButton.layer.cornerRadius = 5.0;

}

- (void)viewWillAppear:(BOOL)animated {
    _trackingAccountLabel.text = [Datasource sharedInstance].bankForTracking.selectedAccount[@"meta"][@"name"];
    
    _fundingAccountLabel.text = [Datasource sharedInstance].bankForFunding.selectedAccount[@"meta"][@"name"];
}

- (IBAction)changeTrackingAccount:(id)sender {
    [Datasource sharedInstance].showTrackingAccountController = YES;
    [self performSegueWithIdentifier:@"changeAccountSettings" sender:self];
    
}
- (IBAction)changeFundingAccount:(id)sender {
    [Datasource sharedInstance].showTrackingAccountController = NO;
    [self performSegueWithIdentifier:@"changeAccountSettings" sender:self];
}
@end
