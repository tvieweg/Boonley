//
//  LimitsViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/17/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "LimitsViewController.h"

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
    //Segue to next view controller here.
}




@end
