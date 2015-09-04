//
//  Datasource.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/12/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "Datasource.h"
#import "Plaid.h"
#import <Parse/Parse.h>

@implementation Datasource

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
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
        self.accountTransactions = [[NSMutableArray alloc] init];
        
    }
    return self;
}

//Get all data to be local. This way account overview is Parse independent. TODO: This data is never stored so if user logs out, data is removed.
- (void) getUserDataForReturningUser {
    if ([PFUser currentUser][@"selectedDonee"] != nil) {
        PFUser *currentUser = [PFUser currentUser];
        _userCharitySelection = currentUser[@"selectedDonee"];
        _minDonation = currentUser[@"minDonation"];
        _maxDonation = currentUser[@"maxDonation"];
        
        [self getUsernameandProfilePicture];

        //Sets access tokens, banks, and selected accounts.
        [self retrieveBankInfoForReturningUser];
        [self updateAccountTransactions]; 
        [self calculateDueDate];
        
    }
}

- (void) retrieveBankInfoForReturningUser {
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

//TODO - add function to specify date to plaid. Setup key value items for changing values.
- (void) updateAccountTransactions {
    if (![self.accessTokens[@"trackingToken"] isEqualToString:@""]) {
        //We have an access token, get available transactions for that account.
        NSString *accountID = self.bankForTracking.selectedAccount[@"_id"];
        
        [Plaid getTransactionalDataWithAccessToken:self.accessTokens[@"trackingToken"] WithCompletionHandler:^(NSDictionary *output) {
            NSDictionary *recentTransactions = output[@"transactions"];
            //Remove objects from account transactions to make way for new ones.
            [self.accountTransactions removeAllObjects];
            self.donationThisMonth = 0;
            
            for (NSDictionary *transaction in recentTransactions) {
                if ([transaction[@"_account"] isEqualToString:accountID]) {
                    [self.accountTransactions addObject:transaction];
                    [self roundUpTransaction:transaction];
                }
            }
        }];
    }
}

- (void) roundUpTransaction:(NSDictionary *)transaction {
    double transactionAmount = [transaction[@"amount"] doubleValue]; 
    double roundedUpTransactionAmount = ceil(transactionAmount);
    double roundUpAmount = roundedUpTransactionAmount - transactionAmount;
    self.donationThisMonth += roundUpAmount;

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

@end
