//
//  AccountPageViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountPageViewController.h"
#import "Datasource.h"
#import <Parse/Parse.h>
#import "BackgroundLayer.h"

@interface AccountPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *accountViewControllers;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AccountPageViewController

- (void) displayErrorAlertWithTitle:(NSString *)title andError:(NSString *)errorString {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated {
    //Check if user is logged in and if not, return to login screen.
    
    self.navigationItem.hidesBackButton = YES;

    if (![PFUser currentUser]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [_activityIndicator startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [[Datasource sharedInstance] retrieveBankInfoForReturningUserWithCompletionHandler:^{
            
            [_activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            //set delegate and datasource, and instantiate view controllers.
            self.delegate = self;
            self.dataSource = self;
            
            UIViewController *p1 = [self.storyboard instantiateViewControllerWithIdentifier:@"accountView1"];
            UIViewController *p2 = [self.storyboard instantiateViewControllerWithIdentifier:@"accountView2"];
            UIViewController *p3 = [self.storyboard instantiateViewControllerWithIdentifier:@"accountView3"];
            
            self.accountViewControllers = @[p1,p2, p3];
            
            [self setViewControllers:@[p1]
                           direction:UIPageViewControllerNavigationDirectionForward
                            animated:NO
                          completion:nil];
        }];
    }

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    //Set background
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    [self.view addSubview:_activityIndicator];
    
    //make sure navigation bar is visible if coming in from login page.
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressSettingButton)];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.accountViewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.accountViewControllers indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (self.accountViewControllers.count);
    return [self.accountViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.accountViewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (self.accountViewControllers.count);
    return [self.accountViewControllers objectAtIndex:currentIndex];
}

-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return self.accountViewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}

-(void) didPressSettingButton {
    [self performSegueWithIdentifier:@"goToProfilePage" sender:self]; 
}

@end
