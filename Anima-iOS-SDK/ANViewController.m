//
//  ANViewController.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 10/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANViewController.h"
#import "ANClassMapping.h"

#define kAnimaNavBarHideDuration 0.25

@implementation ANViewController

/* In order to instantiate your subclass of a VC from a storyboard, map it on ANClassMapping */
+ (instancetype)alloc {
    Class mappedClass = [[ANClassMapping shared] mappedSubclassFor:self];
    if (self == mappedClass) {
        return [super alloc];
    }
    else {
        return [mappedClass alloc];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavigationBar:self.hidesNavBar animated:animated];
}

#pragma mark - Navigation Bar

- (void)hideNavigationBar:(BOOL)hide animated:(BOOL)animated {
    if (self.navigationController.navigationBarHidden == hide) {
        return;
    }
    if (!animated) {
        self.navigationController.navigationBar.alpha = hide ? 0 : 1;
        self.navigationController.navigationBarHidden = hide;
        return;
    }
    if (!hide) {
        self.navigationController.navigationBarHidden = NO;
    }
    self.navigationController.navigationBar.alpha = hide ? 1 : 0;
    [UIView animateWithDuration:kAnimaNavBarHideDuration delay:0 options:kNilOptions animations:^{
        self.navigationController.navigationBar.alpha = hide ? 0 : 1;
    } completion:^(BOOL finished) {
        self.navigationController.navigationBarHidden = hide;
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return (self.lightStatusBar ?
            UIStatusBarStyleLightContent:
            UIStatusBarStyleDefault);
}

- (BOOL)prefersStatusBarHidden {
    return self.hidesStatusBar;
}

#pragma mark - Transitions

- (void)dismiss:(BOOL)animated {
    BOOL shouldPop = self.navigationController.viewControllers.count > 1;
    if (shouldPop) {
        [self.navigationController popViewControllerAnimated:animated];
    }
    else {
        [self dismissViewControllerAnimated:animated completion:^{}];
    }
}

#pragma mark - ANCustomViewDelegate

- (void)view:(UIView *)aView shouldPushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated {
    [self.navigationController pushViewController:
     [self.storyboard instantiateViewControllerWithIdentifier:identifier]
                                         animated:animated];
}

- (void)view:(UIView *)aView shouldPresentViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated {
    [self presentViewController:
     [self.storyboard instantiateViewControllerWithIdentifier:identifier]
                       animated:animated
                     completion:^{}];
}

- (void)view:(UIView *)aView shouldDismissScreenAnimated:(BOOL)animated {
    [self dismiss:animated];
}

@end
