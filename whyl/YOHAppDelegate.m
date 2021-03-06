//
//  YOHAppDelegate.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHAppDelegate.h"

#import <Parse/Parse.h>

#import "YOHMainViewController.h"
#import "YOHAddViewController.h"

@interface YOHAppDelegate () <UIAlertViewDelegate>

@end
@implementation YOHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [Parse setApplicationId:@"CMSZ3FzRNmtH8SuDjQ9KIzjXEnNEcWKcwNR3gsdZ"
                  clientKey:@"n5JtzXX4bR9bhpkcb2Fw4rAfgWfHEF2sbybXSYJw"];
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"alertPresented"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"timeOfAlert"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    YOHMainViewController *mainvc = [YOHMainViewController new];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainvc];
    ((UINavigationController *)self.window.rootViewController).navigationBarHidden = true;
    ((UINavigationController *)self.window.rootViewController).navigationBar.tintColor = [UIColor colorWithRed:247/255.0 green:141/255.0 blue:3/255.0 alpha:1.0];
    ((UINavigationController *)self.window.rootViewController).navigationBar.barTintColor = [UIColor blackColor];
    [((UINavigationController *)self.window.rootViewController).navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:247/255.0 green:141/255.0 blue:3/255.0 alpha:1.0]}];
    
    NSDictionary *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        mainvc.launchedFromNotification = TRUE;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whyl" message:@"Record what you learned today!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    YOHAddViewController *addVc = [[YOHAddViewController alloc] init];
    addVc.title = @"Add";
    [self.window.rootViewController presentViewController:addVc animated:YES completion:nil];
}
@end
