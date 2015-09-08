//
//  AccountTotalsOverviewViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/26/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountTotalsOverviewViewController.h"
#import "Datasource.h"

@interface AccountTotalsOverviewViewController ()

@end

@implementation AccountTotalsOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[Datasource sharedInstance] calculateUserMetrics];
    NSArray *countingLabels = @[_averageDonationCountingLabel, _yearlyTotalDonationsCountingLabel, _allTimeTotalDonationsCountingLabel];
    
    for (UICountingLabel *countingLabel in countingLabels) {
        countingLabel.format = @"$%d";
        countingLabel.method = UILabelCountingMethodLinear;
        countingLabel.textColor = [UIColor whiteColor];
        countingLabel.font = [UIFont systemFontOfSize:36];
        countingLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self.averageDonationCountingLabel countFrom:0 to:[Datasource sharedInstance].averageDonation];
    [self.yearlyTotalDonationsCountingLabel countFrom:0 to:[Datasource sharedInstance].donationsThisYear];
    [self.allTimeTotalDonationsCountingLabel countFrom:0 to:[Datasource sharedInstance].donationsAllTime];

}

@end
