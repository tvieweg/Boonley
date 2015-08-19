//
//  Bank.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/16/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "Bank.h"

@implementation Bank

- (instancetype) initWithBankInfo:(NSDictionary *)bankInfo {
    self = [super init];
    
    if (self) {
        self.accessToken = bankInfo[@"access_token"];
        self.accounts = bankInfo[@"accounts"];
    }
    return self;
}

@end
