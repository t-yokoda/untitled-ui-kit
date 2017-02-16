//
//  ANTabBarController.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 25/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANTabBarController.h"

static __weak ANTabBarController *shared;

@interface ANTabBarController ()
// Exposing selectedIndex to storyboard
@property(nonatomic, assign) IBInspectable NSUInteger selectedIndex;
@property (nonatomic, strong) NSNumber *selectIndexAfterAwake;
@property (nonatomic, assign) BOOL     didAwakeFromNib;
@end


@implementation ANTabBarController

+ (nullable instancetype)shared {
    return shared;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.didAwakeFromNib = YES;
    self.tabBar.hidden = self.hidesTabBar;
    if (self.overlayVCIdentifier) {
        self.overlayVC = [self.storyboard instantiateViewControllerWithIdentifier:self.overlayVCIdentifier];
    }
    if (self.selectIndexAfterAwake) {
        self.selectedIndex = [self.selectIndexAfterAwake unsignedIntegerValue];
    }
    shared = self;
}

- (void)setHidesTabBar:(BOOL)hidesTabBar {
    _hidesTabBar = hidesTabBar;
    self.tabBar.hidden = self.hidesTabBar;
}

- (void)setOverlayVC:(UIViewController<ANTabBarControllerOverlay> *)overlayVC {
    [_overlayVC.view removeFromSuperview];
    [_overlayVC removeFromParentViewController];
    _overlayVC = overlayVC;
    [self setupWithOverlayVC];
}

- (void)setupWithOverlayVC {
    if (self.overlayVC) {
        [self.overlayVC beginAppearanceTransition:YES animated:NO];
        self.overlayVC.view.frame = self.view.bounds;
        self.overlayVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.overlayVC.view];
    }
    [self updateTabBarHierarchy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.overlayVC beginAppearanceTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.overlayVC beginAppearanceTransition:NO animated:animated];
}

- (void)updateTabBarHierarchy {
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    if (!self.overlayVC) {
        [self.view addSubview:self.tabBar];
        return;
    }
    BOOL hasAnAnchorForTabBar = ([self.overlayVC respondsToSelector:@selector(topViewUnderTabBar)] &&
                                 self.overlayVC.topViewUnderTabBar);
    if (hasAnAnchorForTabBar) {
        [self.overlayVC.view insertSubview:self.tabBar aboveSubview:self.overlayVC.topViewUnderTabBar];
    }
    else {
        [self.overlayVC.view addSubview:self.tabBar];
    }
}

#pragma mark -

- (NSUInteger)selectedIndex {
    return super.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    BOOL legalIndex = (self.viewControllers.count > selectedIndex);
    if (!legalIndex) {
        return;
    }
    if (self.didAwakeFromNib) {
        super.selectedIndex = selectedIndex;
    }
    else {
        self.selectIndexAfterAwake = @(selectedIndex);
    }
}

@end


#pragma mark - ANTabBarOverlayView

@implementation ANTabBarOverlayView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    for (UIView *aSubview in self.subviews) {
        if (CGRectContainsPoint(aSubview.frame, point)) {
            return YES;
        }
    }
    return NO; //It's an overlay, ignore touches unless inside subviews
}

@end
