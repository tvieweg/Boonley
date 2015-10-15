//
//  MonthlySummary.h
//  Boonley
//
//  Created by Trevor Vieweg on 9/5/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthlySummary : NSObject

@property (nonatomic, strong) NSMutableArray *transactions;
@property (nonatomic, strong) NSMutableArray *transactionRoundups; 
@property (nonatomic) double donation;
@property (nonatomic, strong) NSDate *monthCreated;

- (instancetype) init; 

@end
