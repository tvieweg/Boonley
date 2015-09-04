//
//  Donation.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/30/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "Donation.h"

@implementation Donation

- (instancetype) initWithAmount:(NSNumber *)amount date:(NSDate *)date donee:(NSString *)donee {
    self = [super init];
    if (self) {
        self.donationAmount = amount;
        self.donationDate = date;
        self.donee = donee; 
    }
    
    return self;
    
}
@end
