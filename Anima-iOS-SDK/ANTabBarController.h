//
//  ANTabBarController.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 25/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANTabBarControllerOverlay;

@interface ANTabBarController : UITabBarController

/** Last ANTabBarController created, will not create one if none. Easier to access across the app. */
+ (nullable instancetype)shared;

/** Will hide the bar */
@property (nonatomic, assign) IBInspectable BOOL hidesTabBar;

/** ANTabBarController will instantiate an overlayVC by this ID on awakeFromNib */
@property (nonatomic, copy, nullable) IBInspectable NSString *overlayVCIdentifier;

/** This will overlay all the content of the TabBarController, allowing floating buttons / notifications across the app */
@property (nonatomic, strong, nullable) UIViewController<ANTabBarControllerOverlay> *overlayVC;

@end


/** Allows controlling Bar hierarchy */
@protocol ANTabBarControllerOverlay <NSObject>
@optional
- (nullable UIView *)topViewUnderTabBar;
@end


/** Ignores touch if not inside subviews, transparent */
@interface ANTabBarOverlayView : UIView
@end
