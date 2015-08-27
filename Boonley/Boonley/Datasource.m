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
        [self updateAccountTransactions];
    }
    return self;
}

- (void) updateAccountTransactions {
    if (![self.accessTokens[@"trackingToken"] isEqualToString:@""]) {
        //We have an access token, get available transactions for that account.
        NSString *accountID = self.bankForTracking.selectedAccount[@"_id"];
        
        [Plaid getTransactionalDataWithAccessToken:self.accessTokens[@"trackingToken"] WithCompletionHandler:^(NSDictionary *output) {
            NSDictionary *recentTransactions = output[@"transactions"];
            //Remove objects from account transactions to make way for new ones.
            [self.accountTransactions removeAllObjects];
            for (NSDictionary *transaction in recentTransactions) {
                if ([transaction[@"_account"] isEqualToString:accountID]) {
                    [self.accountTransactions addObject:transaction];

                }
            }
        }];
    }
}

- (void) getUserIDandProfilePicture {
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
