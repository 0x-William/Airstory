//
//  AppDelegate.m
//  Airstory
//
//  Created by ProDev on 4/6/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "AppDelegate.h"
#import "REFrostedViewController.h"
#import "CustomAFNetworking.h"
#import "MenuVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *contentVC = [storyBoard instantiateInitialViewController];
    
    MenuVC *menuVC = [storyBoard instantiateViewControllerWithIdentifier:@"MENU_VC"];
    menuVC.contentVC = contentVC;
    
    REFrostedViewController *rootVC = [[REFrostedViewController alloc] initWithContentViewController:contentVC menuViewController:menuVC];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    
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
    
    if (self.currentVC != nil && [self.currentVC respondsToSelector:@selector(willEnterActive)]) {
        [self.currentVC performSelector:@selector(willEnterActive) withObject:nil];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.yahoo.com"]];
}
 
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{

//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"com.joanna.Airstory.BackgroundSessionConfig"];
//        configuration.sharedContainerIdentifier = kShareGroupID;
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com"]];
}



@end
