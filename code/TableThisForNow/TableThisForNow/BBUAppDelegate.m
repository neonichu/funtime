//
//  BBUAppDelegate.m
//  TableThisForNow
//
//  Created by Boris Bügling on 15.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUAppDelegate.h"
#import "BBUModelObject.h"

@implementation BBUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BBUModelObject* modelObject = [BBUModelObject new];
    modelObject.foo = @"Hello World";
    modelObject.bar = [NSDate dateWithTimeIntervalSinceNow:10000];
    
    self.dataSource = [[BBUDynamicDataSource alloc] initWithModelObject:modelObject];
    
    UITableViewController* rootVC = [UITableViewController new];
    rootVC.tableView.dataSource = self.dataSource;
    [rootVC.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([modelObject class])];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
