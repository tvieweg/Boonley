//
//  AccountTotalsOverviewViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/26/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountTotalsOverviewViewController.h"

@interface AccountTotalsOverviewViewController ()

@end

@implementation AccountTotalsOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *countingLabels = @[_averageDonationCountingLabel, _yearlyTotalDonationsCountingLabel, _allTimeTotalDonationsCountingLabel];
    
    for (UICountingLabel *countingLabel in countingLabels) {
        countingLabel.format = @"$%d";
        countingLabel.method = UILabelCountingMethodLinear;
        countingLabel.textColor = [UIColor whiteColor];
        countingLabel.font = [UIFont systemFontOfSize:36];
        countingLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    //Dummy counting
    [self.averageDonationCountingLabel countFrom:0 to:35];
    [self.yearlyTotalDonationsCountingLabel countFrom:0 to:230];
    [self.allTimeTotalDonationsCountingLabel countFrom:0 to:1265];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
