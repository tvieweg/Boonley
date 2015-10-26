//
//  InstructionsPageViewController.m
//  Boonley
//
//  Created by Vieweg, Trevor on 10/25/15.
//  Copyright © 2015 Trevor Vieweg. All rights reserved.
//

#import "InstructionsPageViewController.h"
#import "Datasource.h"
#import "BackgroundLayer.h"

@interface InstructionsPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray *instructionViewControllers;

@end

@implementation InstructionsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    //set delegate and datasource, and instantiate view controllers.
    self.delegate = self;
    
    //make sure navigation bar is visible if coming in from login page.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self determineView];
    
}

-(void)determineView {
    if ([Datasource sharedInstance].showInstructions) {
        //if we want to show the instructions, add all views to the list
        self.dataSource = self;
        
        self.navigationItem.rightBarButtonItem = nil;
        
        UIViewController *p1 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView1"];
        UIViewController *p2 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView2"];
        UIViewController *p3 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView3"];
        UIViewController *p4 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView4"];
        UIViewController *p5 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView5"];
        UIViewController *p6 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView6"];
        
        self.instructionViewControllers = @[p1, p2, p3, p4, p5, p6];
        
        [self setViewControllers:@[p1]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    } else {
        
        UIViewController *p6 = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionsView6"];
        
        UIButton* myInfoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [myInfoButton addTarget:self action:@selector(didPressHelp) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myInfoButton];
        
        self.instructionViewControllers = @[p6];
        
        [self setViewControllers:@[p6]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
        
    }

}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.instructionViewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.instructionViewControllers indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (self.instructionViewControllers.count);
    return [self.instructionViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.instructionViewControllers indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (self.instructionViewControllers.count);
    return [self.instructionViewControllers objectAtIndex:currentIndex];
}

-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return self.instructionViewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}

- (void) didPressHelp {
    [Datasource sharedInstance].showInstructions = YES;
    [self determineView];

}

@end
