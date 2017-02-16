//
//  ANTheme.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 10/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/** ANTheme holds a collection of UI settings */
@interface ANTheme : NSObject

@property (nonatomic, strong, nullable) UIColor  *navBarColor;
@property (nonatomic, strong, nullable) UIColor  *navBarButtonsColor;
@property (nonatomic, strong, nullable) UIColor  *navBarTitleColor;
@property (nonatomic, copy, nullable)   NSString *navBarTitleFontName;
@property (nonatomic, assign)           float    navBarTitleFontSize;
@property (nonatomic, assign)           BOOL     navBarIsTranslucent;

@property (nonatomic, strong, nullable) UIColor  *tabBarColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarSelectedButtonsColor;
@property (nonatomic, strong, nullable) UIColor  *tabBarUnselectedButtonsTitleColor;
@property (nonatomic, assign)           BOOL     tabBarIsTranslucent;

/** Applies UI setting */
- (void)apply;

/** Latest ANTheme applied */
+ (nullable ANTheme *)currentTheme;

@end
