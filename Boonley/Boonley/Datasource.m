//
//  Datasource.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/12/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "Datasource.h"
#import "Plaid.h"

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
        
        //Get available institution types from Plaid.
        [Plaid allInstitutionsWithCompletionHandler:^(NSArray *output) {
            self.availableInstitutions = output;
        }];
    }
    return self;
}

@end
