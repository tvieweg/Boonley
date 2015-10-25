//
//  ProfileViewController.h
//  Bartleby
//
//  Created by Trevor Vieweg on 7/20/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PVSettingRow) {
    PVSettingRowAccounts = 0,
    PVSettingRowPassword,
    PVSettingRowLimits,
    PVSettingRowCharity,
    PVSettingRowAbout
};

@interface ProfileViewController : UIViewController

@end
