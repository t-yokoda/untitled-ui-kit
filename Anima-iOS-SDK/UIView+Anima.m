//
//  UIView+Anima.h
//  AnimaSDK-iOS
//
//  Created by Avishay Cohen on 27/07/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "UIView+Anima.h"

@implementation UIView (Anima)

#pragma mark - IBInspectable Properties

- (BOOL)anMasksToBounds {
    return self.layer.masksToBounds;
}

- (void)setAnMasksToBounds:(BOOL)anMasksToBounds {
    self.layer.masksToBounds = anMasksToBounds;
    [self forceMasksToBoundsOnCornerRadius];
}

- (CGFloat)anCornerRadius {
    return self.layer.cornerRadius;
}

- (void)setAnCornerRadius:(CGFloat)anCornerRadius {
    self.layer.cornerRadius  = anCornerRadius;
    [self forceMasksToBoundsOnCornerRadius];
}

- (void)forceMasksToBoundsOnCornerRadius {
    self.layer.masksToBounds = self.anCornerRadius > 0 ? YES : self.layer.masksToBounds;
}

- (UIColor *)anBorderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setAnBorderColor:(UIColor *)anBorderColor {
    self.layer.borderColor = anBorderColor.CGColor;
}

- (CGFloat)anBorderWidth {
    return self.layer.borderWidth;
}

- (void)setAnBorderWidth:(CGFloat)anBorderWidth {
    self.layer.borderWidth = anBorderWidth;
}

- (CGFloat)anRotation {
    NSNumber *rotation = [self valueForKeyPath:@"layer.transform.rotation.z"];
    return ANRadiansToDegrees([rotation floatValue]);
}

- (void)setAnRotation:(CGFloat)anRotation {
    if (anRotation != 0) {
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(ANDegreesToRadians(anRotation));
        CGAffineTransform accumulatedTransform = CGAffineTransformConcat(self.transform, rotationTransform);
        self.transform = accumulatedTransform;
    }
}

@end
