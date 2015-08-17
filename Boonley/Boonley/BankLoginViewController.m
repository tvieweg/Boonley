//
//  BankLoginViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/14/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "BankLoginViewController.h"
#import "Plaid.h"
#import "Datasource.h"

@interface BankLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginToBank:(id)sender;
@property (strong, nonatomic) NSString *bankType;

@end

@implementation BankLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankType =[Datasource sharedInstance].selectedBankType;
    // Do any additional setup after loading the view.
}

- (IBAction)loginToBank:(id)sender {
    [Plaid addUserWithUsername:self.username.text Password:self.password.text Type:self.bankType WithCompletionHandler:^(NSDictionary *output) {
        if (output[@"error"]) {
            NSLog(@"Uh oh there was a problem!");
            //TODO add alert view here
        } else {
            NSLog(@"Logged into %@", output);
            [Datasource sharedInstance].bankForTracking = [[Bank alloc] initWithBankInfo:output];
            [self performSegueWithIdentifier:@"goToAccountOverviewFromBankLogin" sender:self]; 
        }
    }];
}
@end
