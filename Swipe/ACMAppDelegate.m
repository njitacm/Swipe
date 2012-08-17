//
//  ACMAppDelegate.m
//  Swipe
//
//  Created by Grant Butler on 8/6/12.
//  Copyright (c) 2012 ACM. All rights reserved.
//

#import "ACMAppDelegate.h"
#import "ACMPorygonAPIRequest.h"
#import "ACMRootViewController.h"
#import "ACMInventory.h"

@implementation ACMAppDelegate

- (void)_setupAppearance {
	[[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
	[[UINavigationBar appearance] setTitleTextAttributes:@{
								UITextAttributeTextColor: [UIColor colorWithWhite:0.35 alpha:1.0],
						  UITextAttributeTextShadowColor: [UIColor whiteColor],
						 UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)]
	 }];
	
	[[UIBarButtonItem appearance] setTitleTextAttributes:[[UINavigationBar appearance] titleTextAttributes] forState:UIControlStateNormal];
	
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{
								UITextAttributeTextColor: [UIColor colorWithWhite:0.25 alpha:1.0],
						  UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.9 alpha:1.0],
						 UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)]
	 } forState:UIControlStateHighlighted];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self _setupAppearance];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	[ACMPorygonAPIRequest setConsumerToken:@"rUYGlYG7MRxisyrH0Nh9Wq"];
	[ACMPorygonAPIRequest setSecretToken:@"rFzoQiIkQlkACeWFvBgPicgDLXhVEKXzqQFVQA1JZ"];
	
	[[ACMInventory sharedInventory] loadProducts];
	
	ACMRootViewController *rootViewController = [[ACMRootViewController alloc] init];
	self.window.rootViewController = rootViewController;
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
