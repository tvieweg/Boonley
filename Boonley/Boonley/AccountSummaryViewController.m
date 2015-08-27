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
    
    
    //Dummy counting
    [self.monthlyDonationCountingLabel countFrom:0 to:45];
    [self.monthlyTransactionCountingLabel countFrom:0 to:90];
    
    //Dummy counting. Must be in asynchronous call to work properly. 
    dispatch_async(dispatch_get_main_queue(), ^{
        self.monthlyDonationTotal.percent = 0.8;
        self.monthlyTransactionTotal.percent = 0.7;
        
    });
}


@end
