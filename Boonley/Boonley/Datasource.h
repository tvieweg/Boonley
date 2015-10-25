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

typedef void (^CompletionHandler)();

//initialization
+ (instancetype) sharedInstance;

//user ID, service type and advertiser set at initialization
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIImage *userProfilePicture;

@property (strong, nonatomic) NSArray *availableDonees;
@property (strong, nonatomic) NSArray *availableDoneeRatings; 

@property (strong, nonatomic) NSArray *donations; 

//User properties THESE CONTAIN ACCESS TOKENS BE CAREFUL
@property (strong, nonatomic) Bank *bankForTracking;
@property (strong, nonatomic) Bank *bankForFunding;

@property (strong, nonatomic) NSMutableDictionary *accessTokens;

//Charity selection
@property (strong, nonatomic) NSString *userCharitySelection;

//Flags for view controllers
@property (assign, nonatomic) BOOL showTrackingAccountController;
@property (assign, nonatomic) BOOL changingSettings;
@property (nonatomic) BOOL hasCompletedSignUp;

//Track history for this month in current MonthlySummary
@property (strong, nonatomic) MonthlySummary *currentMonthlySummary;
@property (strong, nonatomic) NSMutableArray *monthlySummaries;

//Used to track historical records for user
@property (nonatomic) double donationsAllTime;
@property (nonatomic) double donationsThisYear;
@property (nonatomic) double averageDonation; 

//Limits for donations
@property (strong, nonatomic) NSNumber *minDonation;
@property (strong, nonatomic) NSNumber *maxDonation;

//Time till next payment
@property (nonatomic) NSTimeInterval daysTillPayment;

//Used to populate data for returning users.
- (void) getUserDataForReturningUser;
- (void) retrieveBankInfoForReturningUserWithCompletionHandler:(CompletionHandler)handler;
- (void) calculateUserMetrics;


@end
