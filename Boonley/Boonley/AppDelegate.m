//
//  AppDelegate.m
//  Boonley
//
//  Created by Trevor Vieweg on 8/11/15.
//  Copyright (c) 2015 Trevor Vieweg. All rights reserved.
//

#import "AppDelegate.h"
#import "Plaid.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseTwitterUtils/ParseTwitterUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Plaid setup
    [Plaid setClient:@"PLACE_PRODUCTION_CLIENT_HERE" setSecret:@"PLACE_PRODUCTION_SECRET_HERE" inProduction:NO];
    
    //Parse Setup
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"BXcfMAz5qcYeRjN4vzZDry6l5BmPi14ily77zdn8"
                  clientKey:@"9PGoZkb4pGlF0he7fr40dorsTC3DYWfw48OznCS7"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    [PFTwitterUtils initializeWithConsumerKey:@"jcvsAKoYG1mgeM2xPn8vFzHiB"
                               consumerSecret:@"2Kx6c2PhQaKvPwj3hnxURGbgryo40fecwYXRi9Q3Ng8XQOSfsV"];

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Facebook/Parse Integration

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


@end
