//
//  BBUAppDelegate.h
//  TableThisForNow
//
//  Created by Boris Bügling on 15.05.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBUDynamicDataSource.h"

@interface BBUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) BBUDynamicDataSource* dataSource;
@property (strong, nonatomic) UIWindow *window;

@end
