//
//  AccountSummaryViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountSummaryViewController.h"

@interface AccountSummaryViewController ()

@end

@implementation AccountSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle.text = @"This is the first page";
    
    self.monthlyTransactionTotal.percent = 0.50;
    self.monthlyTransactionTotal.tintColor = [UIColor whiteColor];
    self.monthlyDonationTotal.barStyle = GRKBarStyleFromBottom;
    self.monthlyTransactionTotal.barStyle = GRKBarStyleFromBottom; 
    self.monthlyDonationTotal.percent = 0.50;
    self.monthlyDonationTotal.tintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
