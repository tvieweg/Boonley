//
//  BankAccountTableViewCell.h
//  Boonley
//
//  Created by Vieweg, Trevor on 10/10/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankAccountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@end
