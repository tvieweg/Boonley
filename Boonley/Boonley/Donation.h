//
//  Donation.h
//  Boonley
//
//  Created by Trevor Vieweg on 8/30/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Donation : NSObject

@property (nonatomic, strong) NSNumber *donationAmount;
@property (nonatomic, strong) NSDate *donationDate;
@property (nonatomic, strong) NSString *donee;

- (instancetype) initWithAmount:(NSNumber *)amount date:(NSDate *)date donee:(NSString *)donee; 

@end
