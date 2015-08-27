//
//  AccountPageViewController.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/19/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AccountPageViewController.h"

@interface AccountPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *accountViewControllers;

@end

@implementation AccountPageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
        
    UIViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"accountView1"];
    UIViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"accountView2"];
    
    self.accountViewControllers = @[p1,p2];
    
    [self setViewControllers:@[p1]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
    
    NSLog(@"loaded!");
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

@end
