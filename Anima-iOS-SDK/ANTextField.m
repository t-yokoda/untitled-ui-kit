//
//  ANTextField.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 18/10/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANTextField.h"

@implementation ANTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.attributedText) {
        [self updateAttributes];
    }
    self.placeholder = self.placeholder;
}

#pragma mark - attributedString

- (NSDictionary *)attributesWithColor:(UIColor *)color {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:self.textAlignment];
    NSDictionary *attributes = @{
                                      NSForegroundColorAttributeName:color,
                                      NSParagraphStyleAttributeName:style,
                                      NSFontAttributeName: self.font,
                                      NSKernAttributeName: @(self.letterSpacing),
                                      };
    return attributes;
}

- (NSAttributedString *)attributedStringWithSpacingForText:(NSString *)text color:(UIColor *)color {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text ?: @"" attributes:[self attributesWithColor:color]];
    return attrString;
}

- (void)updateAttributes {
    self.defaultTextAttributes = [self attributesWithColor:self.textColor];
}

#pragma mark - placeholder property

- (BOOL)attributedPlaceholderRequired {
    return self.letterSpacing != 0 || self.placeholderTextColor;
}

- (NSString *)placeholder {
    return super.placeholder ?: super.attributedPlaceholder.string;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if ([self attributedPlaceholderRequired]) {
        UIColor *color = self.placeholderTextColor ?: [ANTextField defaultPlaceholedrColor];
        [super setAttributedPlaceholder:[self attributedStringWithSpacingForText:placeholder color:color]];
    }
    else {
        [super setPlaceholder:placeholder];
    }
}

#pragma mark - updateAttributes triggers

- (void)setLetterSpacing:(float)letterSpacing {
    _letterSpacing = letterSpacing;
    [self updateAttributes];
}

#pragma mark - defaultPlaceholedrColor

+ (UIColor *)defaultPlaceholedrColor {
    static UIColor * defaultPlaceholedrColor = nil;
    if (!defaultPlaceholedrColor) {
        defaultPlaceholedrColor = [UIColor colorWithRed:187/255.0 green:186/255.0 blue:194/255.0 alpha:1];
    }
    return defaultPlaceholedrColor;
}

@end
