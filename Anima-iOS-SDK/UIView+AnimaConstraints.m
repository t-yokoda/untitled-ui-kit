//
//  UIView+AnimaConstraints.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 15/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "UIView+AnimaConstraints.h"

#define ANMinimumMultiplier         0.001                   // Constraints may throw exceptions for small values
#define ANEpsilonForZero(x)         (x == 0 ? 0.00001 : x)  // Multiplier 0 is illegal
#define ANConstraintPriorityBase    920                     // Preventing conflicts

@implementation UIView (AnimaConstraints)

- (void)anRemoveAllFrameConstraints {
    NSArray *constraintsToDeactivate = [self.constraints arrayByAddingObjectsFromArray:self.superview.constraints];
    constraintsToDeactivate = [constraintsToDeactivate filteredArrayUsingPredicate:
                               [NSPredicate predicateWithBlock:
                                ^BOOL(NSLayoutConstraint *evaluatedObject, NSDictionary<NSString *,id> * bindings) {
                                    return ((evaluatedObject.firstItem == self || evaluatedObject.secondItem == self) &&
                                            (evaluatedObject.firstItem == self.superview || evaluatedObject.secondItem == self.superview ||
                                             !evaluatedObject.firstItem || !evaluatedObject.secondItem));
                                }]];
    [NSLayoutConstraint deactivateConstraints:constraintsToDeactivate];
}

#pragma mark - Constraints to superview

- (NSLayoutConstraint *)anCenterXConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeCenterX item2:self.superview attribute2:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *)anCenterYConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeCenterY item2:self.superview attribute2:NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *)anHeightConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeHeight item2:self.superview attribute2:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *)anWidthConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeWidth item2:self.superview attribute2:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *)anTopConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeTop item2:self.superview attribute2:NSLayoutAttributeBottom]; // Bottom == superview's height
}

- (NSLayoutConstraint *)anBottomConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeBottom item2:self.superview attribute2:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)anLeftConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeLeft item2:self.superview attribute2:NSLayoutAttributeCenterX]; // CenterX == 1/2 superview's width
}

- (NSLayoutConstraint *)anRightConstraint {
    return [self anConstraintWithItem:self attribute:NSLayoutAttributeRight item2:self.superview attribute2:NSLayoutAttributeCenterX]; // CenterX == 1/2 superview's width
}

#pragma mark - Relative constraints

- (void)anSetRelativeConstraint:(ANRelativeConstraint)relativeConstraint constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self anRemoveRelativeConstraint:relativeConstraint];
    NSLayoutAttribute attribute1;
    NSLayoutAttribute attribute2;
    switch (relativeConstraint) {
        case ANRelativeConstraintCenterX:
            attribute1 = NSLayoutAttributeCenterX;
            attribute2 = NSLayoutAttributeCenterX;
            multiplier = 1;
            break;
        case ANRelativeConstraintCenterY:
            attribute1 = NSLayoutAttributeCenterY;
            attribute2 = NSLayoutAttributeCenterY;
            multiplier = 1;
            break;
        case ANRelativeConstraintHeight:
            attribute1 = NSLayoutAttributeHeight;
            attribute2 = NSLayoutAttributeHeight;
            break;
        case ANRelativeConstraintWidth:
            attribute1 = NSLayoutAttributeWidth;
            attribute2 = NSLayoutAttributeWidth;
            break;
        case ANRelativeConstraintTop:
            attribute1 = NSLayoutAttributeTop;
            attribute2 = NSLayoutAttributeBottom; // Bottom == superview's height
            if (multiplier < ANMinimumMultiplier) {
                multiplier = 1;
                attribute2 = NSLayoutAttributeTop;
            }
            break;
        case ANRelativeConstraintLeft:
            attribute1 = NSLayoutAttributeLeft;
            attribute2 = NSLayoutAttributeCenterX;
            multiplier = 2.0 * multiplier; // CenterX * 2 == superview width
            if (multiplier < ANMinimumMultiplier) {
                multiplier = 1;
                attribute2 = NSLayoutAttributeLeft;
            }
            break;
        case ANRelativeConstraintRight:
            attribute1 = NSLayoutAttributeRight;
            attribute2 = NSLayoutAttributeCenterX;
            multiplier = 2.0 * (1.0 - multiplier); // CenterX * 2 == superview width
            constant = -constant;
            if (multiplier < ANMinimumMultiplier) {
                multiplier = 1;
                attribute2 = NSLayoutAttributeLeft;
            }
            break;
        case ANRelativeConstraintBottom:
            attribute1 = NSLayoutAttributeBottom;
            attribute2 = NSLayoutAttributeBottom;
            multiplier = 1.0 - multiplier;
            constant = -constant;
            if (multiplier < ANMinimumMultiplier) {
                multiplier = 1;
                attribute2 = NSLayoutAttributeTop;
            }
            break;
    }
    UIView *item2 = self.superview;
    if (multiplier < ANMinimumMultiplier) {
        item2 = nil;
        attribute2 = NSLayoutAttributeNotAnAttribute;
        multiplier = 1;
    }
    NS_DURING
    [self anCreateConstraintWithItem:self
                           attribute:attribute1
                               item2:item2
                          attribute2:attribute2
                            priority:ANConstraintPriorityBase + relativeConstraint
                          multiplier:multiplier
                            constant:constant];
    NS_HANDLER
    // Constarints has issues with optimizing small values, let us know if it happens mailto:support@animaapp.com
    NSLog(@"Constraints issue: %@", localException);
    NS_ENDHANDLER
}

- (void)anRemoveRelativeConstraint:(ANRelativeConstraint)relativeConstraint {
    NSLayoutConstraint *constraint = [self anRelativeConstraint:relativeConstraint];
    if (constraint) {
        [self.superview removeConstraint:constraint];
    }
}

- (NSLayoutConstraint *)anRelativeConstraint:(ANRelativeConstraint)relativeConstraint {
    NSLayoutConstraint *constraint = nil;
    switch (relativeConstraint) {
        case ANRelativeConstraintTop:
            constraint = self.anTopConstraint;
            break;
        case ANRelativeConstraintBottom:
            constraint = self.anBottomConstraint;
            break;
        case ANRelativeConstraintLeft:
            constraint = self.anLeftConstraint;
            break;
        case ANRelativeConstraintRight:
            constraint = self.anRightConstraint;
            break;
        case ANRelativeConstraintCenterX:
            constraint = self.anCenterXConstraint;
            break;
        case ANRelativeConstraintCenterY:
            constraint = self.anCenterYConstraint;
            break;
        case ANRelativeConstraintHeight:
            constraint = self.anHeightConstraint;
            break;
        case ANRelativeConstraintWidth:
            constraint = self.anWidthConstraint;
            break;
        default:
            break;
    }
    return constraint;
}

#pragma mark - Search & Create

- (NSLayoutConstraint *)anCreateConstraintWithItem:(UIView *)item1
                                         attribute:(NSLayoutAttribute)attribute1
                                             item2:(UIView *)item2
                                        attribute2:(NSLayoutAttribute)attribute2
                                          priority:(UILayoutPriority)priority
                                        multiplier:(CGFloat)multiplier
                                          constant:(CGFloat)constant {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:item1
                                                                  attribute:attribute1
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:item2
                                                                  attribute:attribute2
                                                                 multiplier:ANEpsilonForZero(multiplier)
                                                                   constant:constant];
    constraint.priority = priority;
    constraint.active = YES;
    return constraint;
}

- (NSLayoutConstraint *)anConstraintWithItem:(UIView *)item1
                                   attribute:(NSLayoutAttribute)attribute1
                                       item2:(UIView *)item2
                                  attribute2:(NSLayoutAttribute)attribute2 {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        BOOL matching = (constraint.firstItem == item1 &&
                         constraint.secondItem == item2 &&
                         constraint.firstAttribute == attribute1 &&
                         constraint.secondAttribute == attribute2);
        if (matching) {
            return constraint;
        }
    }
    return nil;
}

- (UIView *)anConstraintOwnerWithOtherItem:(UIView *)other {
    UIView *constraintOwner = nil;
    if (self == other.superview) {
        constraintOwner = self;
    }
    else if (other == self.superview) {
        constraintOwner = other;
    }
    if (self.superview == other.superview) {
        constraintOwner = self.superview;
    }
    return constraintOwner;
}

@end