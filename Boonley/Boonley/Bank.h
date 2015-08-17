//
//  Bank.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/16/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bank : NSObject

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) NSDictionary *selectedAccount;

- (instancetype) initWithBankInfo:(NSDictionary *)bankInfo;

@end
