//
//  RoundupTableViewCell.h
//  Boonley
//
//  Created by Vieweg, Trevor on 10/11/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundupTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *roundupAmount;
@property (weak, nonatomic) IBOutlet UILabel *transactionLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionDate;

@end
