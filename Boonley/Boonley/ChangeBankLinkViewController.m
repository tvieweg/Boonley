//
//  ChangeBankLinkViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 9/15/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "ChangeBankLinkViewController.h"
#import "Datasource.h"
#import "Plaid.h"
#import <Parse/Parse.h>

@interface ChangeBankLinkViewController ()

@end

@implementation ChangeBankLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)saveAccessTokensToParse {
    
    PFUser *currentuser = [PFUser currentUser];
    currentuser[@"trackingToken"] = [Datasource sharedInstance].accessTokens[@"trackingToken"];
    currentuser[@"fundingToken"] = [Datasource sharedInstance].accessTokens[@"fundingToken"];
    
    [self performSegueWithIdentifier:@"goToChangeAccountViewController" sender:self];
}

@end
