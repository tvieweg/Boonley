//
//  BackgroundLayer.h
//  Boonley
//
//  Created by Vieweg, Trevor on 10/12/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BackgroundLayer : NSObject

+(CAGradientLayer *) greyGradient;
+(CAGradientLayer *) blueGradient;
+(CAGradientLayer *) greenGradient; 

@end
