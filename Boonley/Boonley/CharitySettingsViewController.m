//
//  CharitySettingsViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 10/17/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import "CharitySettingsViewController.h"
#import "Datasource.h"
#import "BackgroundLayer.h"

@interface CharitySettingsViewController ()

@property (nonatomic, strong) UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *selectedCharityLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeCharityButton;
- (IBAction)changeCharity:(id)sender;

@end

@implementation CharitySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    self.navigationItem.title = @"Account Settings";
    self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    [self.view addSubview:self.navBar];
    [self.navBar pushNavigationItem:self.navigationItem animated:NO];
    
    _changeCharityButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _changeCharityButton.layer.borderWidth = 1.0;
    _changeCharityButton.layer.cornerRadius = 5.0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    _selectedCharityLabel.text = [Datasource sharedInstance].userCharitySelection;

}

- (IBAction)changeCharity:(id)sender {
    [self performSegueWithIdentifier:@"changeCharity" sender:self];

}
@end
