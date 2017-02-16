//
//  UIView+Anima.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 27/07/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AnimaConstraints.h"


@interface UIView (Anima)
@property (nonatomic, assign) IBInspectable CGFloat anCornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat anBorderWidth;
@property (nonatomic, strong, nonnull) IBInspectable UIColor *anBorderColor;
@property (nonatomic, assign) IBInspectable CGFloat anRotation;
@end


#pragma mark - Macros

#define ANDegreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )
#define ANRadiansToDegrees( radians ) ( ( radians ) / M_PI * 180.0 )