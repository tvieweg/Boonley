//
//  InstructionsViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 10/25/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //make sure navigation bar is visible if coming in from login page.
    self.view.backgroundColor = [UIColor clearColor]; 
}

@end
