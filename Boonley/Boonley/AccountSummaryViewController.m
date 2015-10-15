//
//  AccountSummaryViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountSummaryViewController.h"
#import "Datasource.h"
#import "BackgroundLayer.h"

@interface AccountSummaryViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AccountSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];
    
    self.monthlyTransactionTotal.tintColor = [UIColor whiteColor];
    self.monthlyTransactionTotal.barStyle = GRKBarStyleFromBottom;
    [self.monthlyTransactionTotal setAnimationDuration:2.0];

    self.monthlyDonationTotal.tintColor = [UIColor whiteColor];
    self.monthlyDonationTotal.barStyle = GRKBarStyleFromBottom;
    self.monthlyDonationTotal.animationDuration = 2.0;
    
    self.monthlyTransactionCountingLabel.format = @"%d";
    self.monthlyTransactionCountingLabel.method = UILabelCountingMethodLinear;
    self.monthlyTransactionCountingLabel.textColor = [UIColor whiteColor];
    self.monthlyTransactionCountingLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    self.monthlyTransactionCountingLabel.textAlignment = NSTextAlignmentCenter;
    
    self.monthlyDonationCountingLabel.format = @"$%d";
    self.monthlyDonationCountingLabel.method = UILabelCountingMethodLinear;
    self.monthlyDonationCountingLabel.textColor = [UIColor whiteColor];
    self.monthlyDonationCountingLabel.font = [UIFont systemFontOfSize:36 weight:UIFontWeightLight];
    self.monthlyDonationCountingLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nextDonationDue.text = [NSString stringWithFormat: @"Next donation in %d days!", (int)[Datasource sharedInstance].daysTillPayment];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    
        NSInteger numberOfMonthlyTransactions = [Datasource sharedInstance].currentMonthlySummary.transactions.count;
        
        [self.monthlyDonationCountingLabel countFrom:0 to:[Datasource sharedInstance].currentMonthlySummary.donation];
        [self.monthlyTransactionCountingLabel countFrom:0 to:numberOfMonthlyTransactions];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.monthlyDonationTotal.percent = MAX([Datasource sharedInstance].currentMonthlySummary.donation / [[Datasource sharedInstance].maxDonation doubleValue], 0.05);
            NSLog(@"%@", [Datasource sharedInstance].maxDonation);
            self.monthlyTransactionTotal.percent = MAX(numberOfMonthlyTransactions / 100, 0.05);
            
        });

    
}


@end
