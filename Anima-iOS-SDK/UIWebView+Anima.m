//
//  UIWebView+Anima.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "UIWebView+Anima.h"
#import <objc/runtime.h>

static void *urlAssociationKey;

@implementation UIWebView (Anima)

- (void)setAnUrl:(NSString *)anUrl {
    objc_setAssociatedObject(self, &urlAssociationKey, anUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (anUrl) {
        [self anLoadUrlString:anUrl];
    }
}

- (NSString *)anUrl {
    NSString *address = objc_getAssociatedObject(self, &urlAssociationKey);
    return address;
}

- (void)anLoadUrlString:(NSString *)urlString {
    NSURL *url = nil;
    BOOL isScheme = [urlString containsString:@":"];
    BOOL isLocalFile = !isScheme && urlString.length > 0;
    if (isScheme) {
        url = [NSURL URLWithString:urlString];
    }
    else if (isLocalFile) {
        NSString *fileExtention = [urlString pathExtension];
        NSString *fileName = [urlString stringByDeletingPathExtension];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtention];
        url = filePath ? [NSURL fileURLWithPath:filePath] : nil;
    }
    if (url) {
        [self loadRequest:[NSURLRequest requestWithURL:url]];
    }
}

@end
