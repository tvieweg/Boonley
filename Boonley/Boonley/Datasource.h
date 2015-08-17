//
//  Datasource.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/12/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bank.h"

@interface Datasource : NSObject

@property (strong, nonatomic) NSArray *availableDonees;
@property (strong, nonatomic) NSArray *availableInstitutions;

@property (strong, nonatomic) NSString *selectedBankType;

//User properties THESE CONTAIN ACCESS TOKENS AND MUST BE REMOVED ON LOGOUT
@property (strong, nonatomic) Bank *bankForTracking;
@property (strong, nonatomic) Bank *bankForFunding;

@property (strong, nonatomic) NSString *userCharitySelection;
@property (assign, nonatomic) BOOL showTrackingAccountController;

@property (assign, nonatomic) NSInteger minDonation;
@property (assign, nonatomic) NSInteger maxDonation;

+ (instancetype) sharedInstance;

@end
