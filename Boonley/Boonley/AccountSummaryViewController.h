//
//  AccountSummaryViewController.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GRKBarGraphView/GRKBarGraphView.h>
#import <UICountingLabel/UICountingLabel.h>

@interface AccountSummaryViewController : UIViewController

@property (weak, nonatomic) IBOutlet GRKBarGraphView *monthlyTransactionTotal;

@property (weak, nonatomic) IBOutlet GRKBarGraphView *monthlyDonationTotal;

@property (weak, nonatomic) IBOutlet UICountingLabel *monthlyTransactionCountingLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *monthlyDonationCountingLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextDonationDue;

@end
