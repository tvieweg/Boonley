//
//  Datasource.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/12/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Parse/Parse.h>
#import "Datasource.h"
#import "Plaid.h"

@interface Datasource()


@end

@implementation Datasource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void) fakeMonthlySummaries {
    for (int i = 0; i < 10; i++) {
        MonthlySummary *fakeSummary = [[MonthlySummary alloc] init];
        
        //Subtract month to current date.
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = -i;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        fakeSummary.monthCreated = [calendar dateByAddingComponents:dateComponents toDate:fakeSummary.monthCreated options:0];

        fakeSummary.transactions = self.currentMonthlySummary.transactions;
        fakeSummary.donation = 12 * i;
        
        [self.monthlySummaries addObject:fakeSummary]; 
        
    }
    
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        //Placeholder data until we build this out.
        self.availableDonees = @[@"United Way", @"Salvation Army", @"Feeding America", @"American National Red Cross", @"Heifer International", @"Mayo Clinic"];
        self.accessTokens = [[NSMutableDictionary alloc] initWithObjects:@[@"", @""] forKeys:@[@"trackingToken", @"fundingToken"]];
        //Get available institution types from Plaid.
        [Plaid allInstitutionsWithCompletionHandler:^(NSArray *output) {
            self.availableInstitutions = output;
        }];
        self.monthlySummaries = [[NSMutableArray alloc] init];
        
    }
    return self;
}

#pragma mark - Data Gathering and Calcuation
//Get all data to be local. This way account overview is Parse independent. TODO: This data is never stored so if user logs out, data is removed.
- (void) getUserDataForReturningUser {
    if ([PFUser currentUser][@"selectedDonee"] != nil) {
        PFUser *currentUser = [PFUser currentUser];
        _userCharitySelection = currentUser[@"selectedDonee"];
        _minDonation = currentUser[@"minDonation"];
        _maxDonation = currentUser[@"maxDonation"];
        
        [self getUsernameandProfilePicture];
        [self retrieveMonthlySummaries];

        //Sets access tokens, banks, and selected accounts.
        [self retrieveBankInfoForReturningUserWithCompletionHandler:nil];
        [self calculateDueDate];
        [self calculateUserMetrics];
        
    }
}

- (void) getUsernameandProfilePicture {
    if ([PFUser currentUser]) {
        self.username = [PFUser currentUser].username;
        PFFile *userProfilePicture = [PFUser currentUser][@"profilePicture"];
        [userProfilePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (imageData && !error) {
                self.userProfilePicture = [UIImage imageWithData:imageData];
            } else {
                self.userProfilePicture = nil;
            }
        }];
    }
}

- (void) calculateUserMetrics {
    if (_monthlySummaries.count) {
        //Reset any previous values.
        _donationsAllTime = 0;
        _donationsThisYear = 0;
        _averageDonation = 0;
        
        for (MonthlySummary *summary in _monthlySummaries) {
            
            //Add all transactions to all time and average donations
            _donationsAllTime += summary.donation;
            _averageDonation += summary.donation;
            
            
            //See if summary is in same calendar year and if so, add it to donations this year.
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate:[NSDate date]];
            
            if([self date:summary.monthCreated fallsWithYear:dateComponents.year]){
                _donationsThisYear += summary.donation;
            }
        }
        
        //Divide total donations by count for average.
        _averageDonation /= self.monthlySummaries.count;
    }
}

- (void) retrieveMonthlySummaries {
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser[@"monthlySummaries"] != nil) {
        
        _monthlySummaries = currentUser[@"monthlySummaries"];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate:[NSDate date]];
        
        BOOL foundCurrentSummary = NO;
        
        for (MonthlySummary *summary in currentUser[@"monthlySummaries"]) {
            
            if([self date:summary.monthCreated fallsWithYear:dateComponents.year andMonth:dateComponents.month]){
                foundCurrentSummary = YES;
                self.currentMonthlySummary = summary;
            }
        }
        
        if (!foundCurrentSummary) {
            self.currentMonthlySummary = [[MonthlySummary alloc] init];
        }
        
    } else {
        self.currentMonthlySummary = [[MonthlySummary alloc] init];
    }
}

- (void) retrieveBankInfoForReturningUserWithCompletionHandler:(CompletionHandler)handler {
    PFUser *currentUser = [PFUser currentUser];
    _accessTokens[@"trackingToken"] = currentUser[@"trackingToken"];
    _accessTokens[@"fundingToken"] = currentUser[@"fundingToken"];
    [Plaid getTransactionalDataWithAccessToken:currentUser[@"trackingToken"] WithCompletionHandler:^(NSDictionary *output) {
        _bankForTracking = [[Bank alloc] initWithBankInfo:output];
        for (NSDictionary *account in _bankForTracking.accounts) {
            if ([currentUser[@"accountIDForTracking"] isEqualToString:account[@"_id"]]) {
                _bankForTracking.selectedAccount = account;
            }
        }
        
        [self updateAccountTransactionsWithCompletionHandler:handler];
    }];
    
    [Plaid getTransactionalDataWithAccessToken:currentUser[@"fundingToken"] WithCompletionHandler:^(NSDictionary *output) {
        _bankForFunding = [[Bank alloc] initWithBankInfo:output];
        
        for (NSDictionary *account in _bankForFunding.accounts) {
            if ([currentUser[@"accountIDForTracking"] isEqualToString:account[@"_id"]]) {
                _bankForFunding.selectedAccount = account;
            }
        }
    }];
}

#pragma mark - Payment Date

- (void) calculateDueDate {
    NSDate *today = [NSDate date];
    NSDate *dueDate = [PFUser currentUser][@"paymentDate"];
    
    NSLog(@"Old due date is %@", dueDate);
    
    if (!dueDate || [dueDate timeIntervalSinceDate:today] < 0) {
        //update dueDate, it either does not exist or it is past today (i.e. it is last month's due date.)
        
        //Add month to current date.
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 1;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        dueDate = [calendar dateByAddingComponents:dateComponents toDate:today options:0];
        
        //Now reset date components to due date (which is updated to next month), and set day to the first.
        dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate:dueDate];
        dateComponents.day = 1;
        dueDate = [calendar dateFromComponents:dateComponents];
        NSLog(@"New due date is %@", dueDate);
        
        //Save the new dueDate to parse.
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentuser = [PFUser currentUser];
            currentuser[@"paymentDate"] = dueDate;
            [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    return;
                    
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    
                    NSLog(@"Something broke in setting date %@", errorString);
                }
            }];
        });
    }
    
    NSTimeInterval secondsTillDueDate = [dueDate timeIntervalSinceNow];
    NSTimeInterval daysTillDueDate = secondsTillDueDate / 86400;
    self.daysTillPayment = ceil(daysTillDueDate);
    
    NSLog(@"%f days until payment due!", self.daysTillPayment);
}

#pragma mark - Date Helper Functions

-(BOOL)date:(NSDate *)date fallsWithYear:(NSInteger)year {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate:date];
    
    if(dateComponents.year == year) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)date:(NSDate *)date fallsWithYear:(NSInteger)year andMonth:(NSInteger)month {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate:date];
    
    
    if(dateComponents.year == year && dateComponents.month == month) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Transaction Updates
//TODO - add function to specify date to plaid. Setup key value items for changing values.
- (void) updateAccountTransactionsWithCompletionHandler:(CompletionHandler)handler {
    if (![self.accessTokens[@"trackingToken"] isEqualToString:@""]) {
        //We have an access token, get available transactions for that account.
        NSString *accountID = self.bankForTracking.selectedAccount[@"_id"];
        
        [Plaid getTransactionalDataWithAccessToken:self.accessTokens[@"trackingToken"] WithCompletionHandler:^(NSDictionary *output) {
            NSDictionary *recentTransactions = output[@"transactions"];
            //Remove objects from account transactions to make way for new ones.
            [self.currentMonthlySummary.transactions removeAllObjects];
            self.currentMonthlySummary.donation = 0;
            
            for (NSDictionary *transaction in recentTransactions) {
                if ([transaction[@"_account"] isEqualToString:accountID]) {
                    [self.currentMonthlySummary.transactions addObject:transaction];
                    [self roundUpTransaction:transaction];
                }
            }
            
            [self fakeMonthlySummaries]; 

            if (handler) {
                handler();
            }
        }];
        
    }
}

- (void) roundUpTransaction:(NSDictionary *)transaction {
    double transactionAmount = [transaction[@"amount"] doubleValue]; 
    double roundedUpTransactionAmount = ceil(transactionAmount);
    double roundUpAmount = roundedUpTransactionAmount - transactionAmount;
    self.currentMonthlySummary.donation += roundUpAmount;

}

@end
