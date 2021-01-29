//
//  AppDelegate.m
//  FaceCamera
//
//  Created by tigerfly on 2021/1/29.
//  Copyright © 2021 tigerfly. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ARExperienceController.h"
#import "MetalViewController.h"
#import "Essentials.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    Essentials *vc = [Essentials new];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}




@end
