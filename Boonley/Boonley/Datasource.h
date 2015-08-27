//
//  Datasource.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/12/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Bank.h"

@interface Datasource : NSObject

//user ID, service type and advertiser set at initialization
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIImage *userProfilePicture;

@property (strong, nonatomic) NSArray *availableDonees;
@property (strong, nonatomic) NSArray *availableInstitutions;

//User properties THESE CONTAIN ACCESS TOKENS
@property (strong, nonatomic) Bank *bankForTracking;
@property (strong, nonatomic) Bank *bankForFunding;

@property (strong, nonatomic) NSMutableDictionary *accessTokens;
@property (strong, nonatomic) NSMutableArray *accountTransactions; 

@property (strong, nonatomic) NSString *userCharitySelection;
@property (assign, nonatomic) BOOL showTrackingAccountController;

@property (assign, nonatomic) NSInteger minDonation;
@property (assign, nonatomic) NSInteger maxDonation;
- (void) updateAccountTransactions; 

+ (instancetype) sharedInstance;

@end
