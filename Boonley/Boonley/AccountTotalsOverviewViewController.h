//
//  AccountTotalsOverviewViewController.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/26/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICountingLabel/UICountingLabel.h>

@interface AccountTotalsOverviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICountingLabel *averageDonationCountingLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *yearlyTotalDonationsCountingLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *allTimeTotalDonationsCountingLabel;

@end
