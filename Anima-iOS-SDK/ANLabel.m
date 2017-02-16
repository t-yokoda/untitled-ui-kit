//
//  ANLabel.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 18/10/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANLabel.h"

@implementation ANLabel

- (void)drawRect:(CGRect)rect {
#if TARGET_INTERFACE_BUILDER
    [super setAttributedText:[self attributedStringWithSpacingForText:text]];
#endif
    [super drawRect:rect];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.attributedText) {
        [self updateTextIfAttributed];
    }
}

- (void)drawTextInRect:(CGRect) rect {

    // Sketch text layer vertical alignment is Top, UILabel by default is Middle. This makes ANLabel vertical alignment Top.
    // http://stackoverflow.com/a/10681299/413289
    rect.size.height = [self.attributedText boundingRectWithSize:rect.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil].size.height;
    rect.size.height = ceil(rect.size.height);
    if (self.numberOfLines != 0) {
        rect.size.height = MIN(rect.size.height, self.numberOfLines * self.font.lineHeight);
    }
    [super drawTextInRect:rect];
}

#pragma mark - attributedString

- (NSAttributedString *)attributedStringWithSpacingForText:(NSString *)text {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:self.textAlignment];
    style.maximumLineHeight = style.minimumLineHeight = self.lineHeight;
    style.paragraphSpacing = self.paragraphSpacing;
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName:self.textColor,
                                 NSParagraphStyleAttributeName:style,
                                 NSFontAttributeName: self.font,
                                 NSKernAttributeName: @(self.letterSpacing)
                                 };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text ?: @"" attributes:attributes];
    if (self.lineHeight > self.font.lineHeight) {
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@((self.lineHeight/2 - self.font.lineHeight/2)/2) range:(NSRange){0, attributedString.length}];
    }
    return attributedString;
}

- (BOOL)attributedTextRequired {
    return self.lineHeight != 0 || self.letterSpacing != 0 || self.paragraphSpacing != 0;
}

- (void)updateTextIfAttributed {
    if ([self attributedTextRequired]) {
        self.text = self.text;
    }
}

#pragma mark - text property

- (NSString *)text {
    return super.text ?: super.attributedText.string;
}

- (void)setText:(NSString *)text {
    if ([self attributedTextRequired]) {
        [super setAttributedText:[self attributedStringWithSpacingForText:text]];
    }
    else {
        [super setText:text];
    }
}

#pragma mark - updateTextIfAttributed triggers

- (void)setLetterSpacing:(float)letterSpacing {
    _letterSpacing = letterSpacing;
    [self updateTextIfAttributed];
}

- (void)setLineHeight:(NSUInteger)lineHeight {
    _lineHeight = lineHeight;
    [self updateTextIfAttributed];
}

- (void)setParagraphSpacing:(float)paragraphSpacing {
    _paragraphSpacing = paragraphSpacing;
    [self updateTextIfAttributed];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self updateTextIfAttributed];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    [self updateTextIfAttributed];
}

@end
