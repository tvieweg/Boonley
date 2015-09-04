//
//  AccountSummaryViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountSummaryViewController.h"
#import "Datasource.h"

@interface AccountSummaryViewController ()

@end

@implementation AccountSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.monthlyTransactionTotal.tintColor = [UIColor whiteColor];
    self.monthlyTransactionTotal.barStyle = GRKBarStyleFromBottom;
    [self.monthlyTransactionTotal setAnimationDuration:2.0];

    self.monthlyDonationTotal.tintColor = [UIColor whiteColor];
    self.monthlyDonationTotal.barStyle = GRKBarStyleFromBottom;
    self.monthlyDonationTotal.animationDuration = 2.0;
    
    self.monthlyTransactionCountingLabel.format = @"%d";
    self.monthlyTransactionCountingLabel.method = UILabelCountingMethodLinear;
    self.monthlyTransactionCountingLabel.textColor = [UIColor whiteColor];
    self.monthlyTransactionCountingLabel.font = [UIFont systemFontOfSize:36];
    self.monthlyTransactionCountingLabel.textAlignment = NSTextAlignmentCenter;
    
    self.monthlyDonationCountingLabel.format = @"$%d";
    self.monthlyDonationCountingLabel.method = UILabelCountingMethodLinear;
    self.monthlyDonationCountingLabel.textColor = [UIColor whiteColor];
    self.monthlyDonationCountingLabel.font = [UIFont systemFontOfSize:36];
    self.monthlyDonationCountingLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nextDonationDue.text = [NSString stringWithFormat: @"Next donation in %d days!", (int)[Datasource sharedInstance].daysTillPayment];
    
    NSInteger numberOfMonthlyTransactions = [Datasource sharedInstance].accountTransactions.count;

    [self.monthlyDonationCountingLabel countFrom:0 to:[Datasource sharedInstance].donationThisMonth];
    [self.monthlyTransactionCountingLabel countFrom:0 to:numberOfMonthlyTransactions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.monthlyDonationTotal.percent = MAX([Datasource sharedInstance].donationThisMonth / [[Datasource sharedInstance].maxDonation doubleValue], 0.05);
        NSLog(@"%@", [Datasource sharedInstance].maxDonation); 
        self.monthlyTransactionTotal.percent = MAX(numberOfMonthlyTransactions / 100, 0.05);
        
    });
}


@end
