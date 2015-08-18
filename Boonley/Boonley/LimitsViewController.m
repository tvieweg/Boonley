//
//  LimitsViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/17/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "LimitsViewController.h"
#import "Datasource.h"

@interface LimitsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *minimumDonation;
@property (weak, nonatomic) IBOutlet UITextField *maximumDonation;
@end

@implementation LimitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(didPressNext)];
    
}

- (void) didPressNext {
    if ([self.minimumDonation.text integerValue] >= 5 && [self.maximumDonation.text integerValue] > [self.minimumDonation.text integerValue]) {
        [Datasource sharedInstance].minDonation = [self.minimumDonation.text integerValue];
        [Datasource sharedInstance].maxDonation = [self.maximumDonation.text integerValue];
        [self performSegueWithIdentifier:@"goToAccountOverviewFromSignup" sender:self];
    } else {
        NSLog(@"There's something wrong with the inputs. Inform the user.");
    }
}




@end
