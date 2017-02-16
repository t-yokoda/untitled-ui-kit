//
//  ANGradientView.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/** ANGradientView is a storyboard-friendly view for 2 colors gradient */
IB_DESIGNABLE

@interface ANGradientView : UIView
@property (nonatomic, strong, nullable) IBInspectable UIColor *anColor1;
@property (nonatomic, strong, nullable) IBInspectable UIColor *anColor2;
@end
