//
//  AppDelegate.m
//  GBLW
//
//  Created by iosdevlope on 2017/10/12.
//  Copyright © 2017年 iosdevlope. All rights reserved.
//

#import "AppDelegate.h"
#import "GBHomeViewController.h"
#import "GBTabBarController.h"
#import "GBTopicViewController.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    GBHomeViewController *hvc = [[GBHomeViewController alloc] init];
    UINavigationController *hNavc = [[UINavigationController alloc] initWithRootViewController:hvc];
    hNavc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:ImageNamed(@"rec_unsel") selectedImage:[ImageNamed(@"rec_sel") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self setTabBarItemTextColor:hNavc.tabBarItem];
    
    GBTopicViewController *tvc = [[GBTopicViewController alloc] init];
    UINavigationController *tNavc = [[UINavigationController alloc] initWithRootViewController:tvc];
    tNavc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"圈子" image:ImageNamed(@"topic_unsel") selectedImage:[ImageNamed(@"topic_sel") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self setTabBarItemTextColor:tNavc.tabBarItem];
    
    GBTabBarController *tabVC = [[GBTabBarController alloc] init];
    tabVC.delegate = self;
    tabVC.viewControllers = @[hNavc, tNavc];
    tabVC.tabBar.alpha = 1.0;
    tabVC.tabBar.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabVC];
    nav.navigationBar.hidden = YES;
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setTabBarItemTextColor:(UITabBarItem *)tabBarItem {
    NSDictionary *rootHome = [NSDictionary dictionaryWithObject:ColorHex(@"7c7c7c") forKey:NSForegroundColorAttributeName];
    [tabBarItem setTitleTextAttributes:rootHome forState:UIControlStateNormal];
    
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:ColorHex(@"ffc000") forKey:NSForegroundColorAttributeName];
    [tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

@end
