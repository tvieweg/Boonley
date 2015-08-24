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
    self.pageTitle.text = @"This is the first page";
    
    self.monthlyTransactionTotal.tintColor = [UIColor whiteColor];
    self.monthlyTransactionTotal.barStyle = GRKBarStyleFromBottom;
    [self.monthlyTransactionTotal setAnimationDuration:0.5];

    self.monthlyDonationTotal.tintColor = [UIColor whiteColor];
    self.monthlyDonationTotal.barStyle = GRKBarStyleFromBottom;
    self.monthlyDonationTotal.animationDuration = 1.0; 
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.monthlyDonationTotal.percent = 1.0;

}


@end
