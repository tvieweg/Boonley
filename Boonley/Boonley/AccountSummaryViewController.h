//
//  AccountSummaryViewController.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GRKBarGraphView/GRKBarGraphView.h>

@interface AccountSummaryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pageTitle;

@property (weak, nonatomic) IBOutlet GRKBarGraphView *monthlyTransactionTotal;

@property (weak, nonatomic) IBOutlet GRKBarGraphView *monthlyDonationTotal;

@end
