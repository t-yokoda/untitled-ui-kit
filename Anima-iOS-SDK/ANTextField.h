//
//  ANTextField.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 18/10/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
NS_ASSUME_NONNULL_BEGIN

/** ANTextField gives easier access to text spacing, and allows custom placeholder text color. Its properties are available in storyboard. */
@interface ANTextField : UITextField

/** Text Letter spacing in points. 0 is the default. */
@property (nonatomic, assign) IBInspectable float letterSpacing;

/** Text Paragraph spacing in points. RGB(187,186,194) is the default when set to nil. */
@property (nonatomic, strong) IBInspectable UIColor *placeholderTextColor;

@end

NS_ASSUME_NONNULL_END
