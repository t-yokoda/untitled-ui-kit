//
//  ANGradientView.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANGradientView.h"
#import <QuartzCore/QuartzCore.h>

@interface ANGradientView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ANGradientView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGradientLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupGradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayerFrame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateGradientLayerFrame];
}

#pragma mark - Layer

- (void)setupGradientLayer {
    if (self.gradientLayer) {
        return;
    }
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.contentsGravity = kCAGravityResize;
    [self.layer addSublayer:self.gradientLayer];
    self.backgroundColor = [UIColor clearColor];
    [self updateGradientLayer];
}

- (void)updateGradientLayer {
    if (self.anColor1 && self.anColor2) {
        self.gradientLayer.colors = @[(id)self.anColor1.CGColor,
                                      (id)self.anColor2.CGColor];
    }
}

- (void)updateGradientLayerFrame {
    self.gradientLayer.frame = self.bounds;
    [self.gradientLayer removeAllAnimations];
}

#pragma mark - Colors

- (void)setAnColor1:(UIColor *)anColor1 {
    _anColor1 = anColor1;
    [self updateGradientLayer];
}

- (void)setAnColor2:(UIColor *)anColor2 {
    _anColor2 = anColor2;
    [self updateGradientLayer];
}

@end
