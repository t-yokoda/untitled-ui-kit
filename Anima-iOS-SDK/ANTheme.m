//
//  ANTheme.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 10/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANTheme.h"
@import CoreText;

static ANTheme *currentTheme;

@implementation ANTheme

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadCustomFonts];
    });
}

+ (void)loadCustomFonts {
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [frameworkBundle resourcePath];
    NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:nil];
    NSArray *fontFiles = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.ttf' OR self ENDSWITH '.otf'"]];
    [fontFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self loadFontWithName:[resourcePath stringByAppendingPathComponent:obj]];
    }];
}

+ (void)loadFontWithName:(NSString *)fontPath {
    NSData *fontData = [NSData dataWithContentsOfFile:fontPath];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    if (provider) {
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (font) {
            CFErrorRef error = NULL;
            if (CTFontManagerRegisterGraphicsFont(font, &error) == NO) {
                CFStringRef errorDescription = CFErrorCopyDescription(error);
                NSLog(@"Failed to load font: %@", errorDescription);
                CFRelease(errorDescription);
            }
            CFRelease(font);
        }
        CFRelease(provider);
    }
}

+ (ANTheme *)currentTheme {
    return currentTheme;
}

- (void)apply {
    [self applyNavBar];
    [self applyTabBar];
}

- (void)applyNavBar {
    [[UINavigationBar appearance] setTintColor:self.navBarButtonsColor];
    [[UINavigationBar appearance] setBarTintColor:self.navBarColor];
    [[UINavigationBar appearance] setTranslucent:self.navBarIsTranslucent];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (self.navBarTitleColor) {
        attributes[NSForegroundColorAttributeName] = self.navBarTitleColor;
    }
    if (self.navBarTitleFontName) {
        UIFont *titleFont = [UIFont fontWithName:self.navBarTitleFontName size:self.navBarTitleFontSize];
        attributes[NSFontAttributeName] = titleFont;
    }
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    currentTheme = self;
}

- (void)applyTabBar {
    if (self.tabBarColor) {
        [[UITabBar appearance] setBarTintColor:self.tabBarColor];
    }
    if (self.tabBarSelectedButtonsColor) {
        [[UITabBar appearance] setTintColor:self.tabBarSelectedButtonsColor];
        NSDictionary *attributes = @{ NSForegroundColorAttributeName : self.tabBarSelectedButtonsColor };
        [UITabBarItem.appearance setTitleTextAttributes:attributes
                                               forState:UIControlStateSelected];
    }
    if (self.tabBarUnselectedButtonsTitleColor) {
        NSDictionary *attributes = @{ NSForegroundColorAttributeName : self.tabBarUnselectedButtonsTitleColor };
        [UITabBarItem.appearance setTitleTextAttributes:attributes
                                               forState:UIControlStateNormal];
    }
    [[UITabBar appearance] setTranslucent:self.tabBarIsTranslucent];

}

@end
