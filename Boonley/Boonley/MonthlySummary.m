//
//  MonthlySummary.m
//  Boonley
//
//  Created by Trevor Vieweg on 9/5/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "MonthlySummary.h"

@implementation MonthlySummary

- (instancetype) init {
    self = [super init];
    
    if (self) {
        _transactions = [[NSMutableArray alloc] init];
        _transactionRoundups = [[NSMutableArray alloc] init]; 
        _monthCreated = [NSDate date];
    }
    
    return self;
    
}

@end
