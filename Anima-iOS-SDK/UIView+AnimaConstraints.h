//
//  UIView+AnimaConstraints.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 15/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ANRelativeConstraintCenterX,
    ANRelativeConstraintCenterY,
    ANRelativeConstraintHeight,
    ANRelativeConstraintWidth,
    ANRelativeConstraintTop,
    ANRelativeConstraintLeft,
    ANRelativeConstraintRight,
    ANRelativeConstraintBottom,
} ANRelativeConstraint;


NS_ASSUME_NONNULL_BEGIN
@interface UIView (AnimaConstraints)

/** Removes all constraints to superview or absolute width/height */
- (void)anRemoveAllFrameConstraints;

/** ANRelativeConstraint constraint gives you the power to set the distance from superview edges.
  * i.e: ANRelativeConstraintLeft with multiplier 0.3 will set left side to 30% of super's width. */

- (void)anSetRelativeConstraint:(ANRelativeConstraint)rc constant:(CGFloat)constant multiplier:(CGFloat)multiplier;
- (void)anRemoveRelativeConstraint:(ANRelativeConstraint)rc;
- (nullable NSLayoutConstraint *)anRelativeConstraint:(ANRelativeConstraint)rc;

#pragma mark - Search & Create constraints

- (nullable NSLayoutConstraint *)anCreateConstraintWithItem:(UIView *)item1
                                                  attribute:(NSLayoutAttribute)attribute1
                                                      item2:(UIView *)item2
                                                 attribute2:(NSLayoutAttribute)attribute2
                                                   priority:(UILayoutPriority)priority
                                                 multiplier:(CGFloat)multiplier
                                                   constant:(CGFloat)constant;
- (nullable NSLayoutConstraint *)anConstraintWithItem:(UIView *)item1
                                            attribute:(NSLayoutAttribute)attribute1
                                                item2:(UIView *)item2
                                           attribute2:(NSLayoutAttribute)attribute2;
- (nullable UIView *)anConstraintOwnerWithOtherItem:(UIView *)other;

@end
NS_ASSUME_NONNULL_END