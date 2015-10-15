//
//  ChangeBankAccountTableViewCell.h
//  Boonley
//
//  Created by Vieweg, Trevor on 10/11/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeBankAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *balance;

@end
