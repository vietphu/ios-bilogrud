//
//  AppDelegate.h
//  SimpleReader
//
//  Created by Natasha on 03.12.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class PageViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) PageViewController* pageViewController;
@end
