//
//  ChangeLimitsViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 9/15/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "ChangeLimitsViewController.h"
#import "Datasource.h"
#import <EFCircularSlider/EFCircularSlider.h>
#import <Parse/Parse.h>
#import <ZFCheckbox/ZFCheckbox.h>
#import "BackgroundLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface ChangeLimitsViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *minDonation;
@property (weak, nonatomic) IBOutlet UILabel *maxDonation;
@property (weak, nonatomic) IBOutlet UIView *minValueSliderFrame;
@property (weak, nonatomic) IBOutlet UIView *maxValueSliderFrame;
@property (strong, nonatomic) EFCircularSlider *minValueCircularSlider;
@property (strong, nonatomic) EFCircularSlider *maxValueCircularSlider;
@property (assign, nonatomic) NSInteger minDonationValue;
@property (assign, nonatomic) NSInteger maxDonationValue;

@end

@implementation ChangeLimitsViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:errorString
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didPressDone)];
    _minDonation.text = [[Datasource sharedInstance].minDonation stringValue];
    _maxDonation.text = [[Datasource sharedInstance].maxDonation stringValue];
    
    _minValueCircularSlider = [[EFCircularSlider alloc] initWithFrame:_minValueSliderFrame.frame];
    [_minValueCircularSlider addTarget:self action:@selector(minValueChanged:) forControlEvents:UIControlEventValueChanged];
    _minValueCircularSlider.unfilledColor = [UIColor lightGrayColor];
    _minValueCircularSlider.filledColor = [UIColor whiteColor];
    _minValueCircularSlider.lineWidth = 15;
    _minValueCircularSlider.handleType = EFSemiTransparentWhiteCircle;
    _minValueCircularSlider.handleColor = _minValueCircularSlider.filledColor;
    [_minValueCircularSlider setMinimumValue:1];
    [_minValueCircularSlider setMaximumValue:1000];
    [_minValueCircularSlider setCurrentValue:[Datasource sharedInstance].minDonation.floatValue];
    _minDonationValue = _minValueCircularSlider.currentValue;
    [self.view addSubview:_minValueCircularSlider];
    
    _maxValueCircularSlider = [[EFCircularSlider alloc] initWithFrame:_maxValueSliderFrame.frame];
    [_maxValueCircularSlider addTarget:self action:@selector(maxValueChanged:) forControlEvents:UIControlEventValueChanged];
    _maxValueCircularSlider.unfilledColor = [UIColor lightGrayColor];
    _maxValueCircularSlider.filledColor = [UIColor whiteColor];
    _maxValueCircularSlider.lineWidth = 15;
    _maxValueCircularSlider.handleType = EFSemiTransparentWhiteCircle;
    _maxValueCircularSlider.handleColor = _maxValueCircularSlider.filledColor;
    [_maxValueCircularSlider setMinimumValue:5];
    [_maxValueCircularSlider setMaximumValue:1000];
    [_maxValueCircularSlider setCurrentValue:[Datasource sharedInstance].maxDonation.floatValue];
    _maxDonationValue = _maxValueCircularSlider.currentValue;
    [self.view addSubview:_maxValueCircularSlider];
    
}

-(void)viewDidLayoutSubviews {
    _minValueCircularSlider.frame = _minValueSliderFrame.frame;
    _maxValueCircularSlider.frame = _maxValueSliderFrame.frame;
}

-(void)minValueChanged:(EFCircularSlider*)slider {
    //rounds float value to minimum integer value increment of five.
    _minDonationValue = (NSInteger)(5 * floor((slider.currentValue/5)+0.5));
    _minDonation.text = [NSString stringWithFormat:@"$%ld", (long)_minDonationValue];
}

-(void)maxValueChanged:(EFCircularSlider*)slider {
    //rounds float value to minimum integer value increment of five.
    _maxDonationValue = (NSInteger)(5 * floor((slider.currentValue/5)+0.5));
    _maxDonation.text = [NSString stringWithFormat:@"$%ld", (long)_maxDonationValue];
}


- (void) didPressDone {
    if (self.minDonationValue >= 5 && self.maxDonationValue > self.minDonationValue) {
        
        //Changes have been made.
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentuser = [PFUser currentUser];
            
            
            currentuser[@"minDonation"] = [NSNumber numberWithInteger:self.minDonationValue];
            currentuser[@"maxDonation"] = [NSNumber numberWithInteger:self.maxDonationValue];
            
            [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (succeeded) {
                    
                    [Datasource sharedInstance].minDonation = currentuser[@"minDonation"];
                    [Datasource sharedInstance].maxDonation = currentuser[@"maxDonation"];
                    
                    ZFCheckbox *checkbox = [[ZFCheckbox alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
                    checkbox.center = self.view.center;
                    checkbox.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:checkbox];
                    [checkbox setSelected:NO animated:NO];
                    checkbox.animateDuration = 0.5;
                    
                    double delayInSeconds = 0.05;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [checkbox setSelected:YES animated:YES];
                    });
                    
                    delayInSeconds = 1.0;
                    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.navigationController popViewControllerAnimated:YES];
                    });


                    
                } else {
                    //show user error
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    
                    [self displayErrorAlertWithTitle:@"Something's wrong" andError:errorString];
                }
            }];
        });
        
    } else {
        [self displayErrorAlertWithTitle:@"Error" andError:@"Miminum and maximums not set correctly. Please review your minimum and maximums"];
    }
}


@end
