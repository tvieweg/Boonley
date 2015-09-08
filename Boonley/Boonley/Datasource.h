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
#import "MonthlySummary.h"

@interface Datasource : NSObject

@property (nonatomic) BOOL hasCompletedSignUp; 

//user ID, service type and advertiser set at initialization
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIImage *userProfilePicture;

@property (strong, nonatomic) NSArray *availableDonees;
@property (strong, nonatomic) NSArray *availableInstitutions;

@property (strong, nonatomic) NSArray *donations; 

//User properties THESE CONTAIN ACCESS TOKENS
@property (strong, nonatomic) Bank *bankForTracking;
@property (strong, nonatomic) Bank *bankForFunding;

@property (strong, nonatomic) NSMutableDictionary *accessTokens;

@property (strong, nonatomic) NSString *userCharitySelection;
@property (assign, nonatomic) BOOL showTrackingAccountController;

//Track history for this month in current MonthlySummary
@property (strong, nonatomic) MonthlySummary *currentMonthlySummary;
@property (strong, nonatomic) NSMutableArray *monthlySummaries;

@property (nonatomic) double donationsAllTime;
@property (nonatomic) double donationsThisYear;
@property (nonatomic) double averageDonation; 


@property (strong, nonatomic) NSNumber *minDonation;
@property (strong, nonatomic) NSNumber *maxDonation;

@property (nonatomic) NSTimeInterval daysTillPayment;

- (void) getUserDataForReturningUser; 
- (void) updateAccountTransactions;
- (void) calculateUserMetrics; 

+ (instancetype) sharedInstance;

@end
