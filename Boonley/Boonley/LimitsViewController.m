//
//  LimitsViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/17/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "LimitsViewController.h"
#import "Datasource.h"
#import <EFCircularSlider/EFCircularSlider.h>
#import <Parse/Parse.h>
#import "BackgroundLayer.h"

@interface LimitsViewController () 

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *minimumDonation;
@property (weak, nonatomic) IBOutlet UILabel *maximumDonation;
@property (weak, nonatomic) IBOutlet UIView *minValueSliderFrame;
@property (weak, nonatomic) IBOutlet UIView *maxValueSliderFrame;
@property (strong, nonatomic) EFCircularSlider *minValueCircularSlider;
@property (strong, nonatomic) EFCircularSlider *maxValueCircularSlider;
@property (assign, nonatomic) NSInteger minDonationValue;
@property (assign, nonatomic) NSInteger maxDonationValue;

@end

@implementation LimitsViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(didPressNext)];
    
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:_activityIndicator];
    
    _minValueCircularSlider = [[EFCircularSlider alloc] initWithFrame:_minValueSliderFrame.frame];
    [_minValueCircularSlider addTarget:self action:@selector(minValueChanged:) forControlEvents:UIControlEventValueChanged];
    _minValueCircularSlider.unfilledColor = [UIColor lightGrayColor];
    _minValueCircularSlider.filledColor = [UIColor whiteColor];
    _minValueCircularSlider.lineWidth = 15;
    _minValueCircularSlider.handleType = EFSemiTransparentWhiteCircle;
    _minValueCircularSlider.handleColor = _minValueCircularSlider.filledColor;
    [_minValueCircularSlider setMinimumValue:1];
    [_minValueCircularSlider setMaximumValue:1000];
    [_minValueCircularSlider setCurrentValue:5];
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
    [_maxValueCircularSlider setCurrentValue:20];
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
    _minimumDonation.text = [NSString stringWithFormat:@"$%ld", (long)_minDonationValue];
}

-(void)maxValueChanged:(EFCircularSlider*)slider {
    //rounds float value to minimum integer value increment of five.
    _maxDonationValue = (NSInteger)(5 * floor((slider.currentValue/5)+0.5));
    _maximumDonation.text = [NSString stringWithFormat:@"$%ld", (long)_maxDonationValue];
}

- (void) didPressNext {
    if (_minDonationValue >= 5 && _maxDonationValue > _minDonationValue) {
        
        //Signup has been COMPLETED!! Save all data to parse.
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFUser *currentuser = [PFUser currentUser];
            
            currentuser[@"minDonation"] = [NSNumber numberWithInteger:_minDonationValue];
            currentuser[@"maxDonation"] = [NSNumber numberWithInteger:_maxDonationValue];
            
            [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [_activityIndicator stopAnimating];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (succeeded) {
                    
                    [Datasource sharedInstance].minDonation = currentuser[@"minDonation"];
                    [Datasource sharedInstance].maxDonation = currentuser[@"maxDonation"];
                    
                    [[Datasource sharedInstance] getUserDataForReturningUser];
                    [self performSegueWithIdentifier:@"goToAccountOverviewFromSignup" sender:self];
                    
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
