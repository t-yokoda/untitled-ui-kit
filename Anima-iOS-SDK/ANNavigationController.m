//
//  ANNavigationController.m
//  Samples
//
//  Created by Avishay Cohen on 18/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANNavigationController.h"

@implementation ANNavigationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[UINavigationBar appearance] barTintColor]) {
        // Smoother when hiding the bar
        self.navigationBar.superview.backgroundColor = [[UINavigationBar appearance] barTintColor];
    }
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

@end
