//
//  UIImageView+Anima.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 22/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "UIImageView+Anima.h"
#import <objc/runtime.h>

#define kCacheLimit 100

static void     *urlAssociationKey;
static void     *tintAssociationKey;
static NSCache  *imageCache;

@implementation UIImageView (Anima)

#pragma mark - Tint

- (void)setAnImageTint:(UIColor *)anImageTint {
    objc_setAssociatedObject(self, &tintAssociationKey, anImageTint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.image && anImageTint) {
        self.image = [UIImageView anTintImage:self.image withColor:anImageTint];
    }
}

- (UIColor *)anImageTint {
    UIColor *anImageTint = objc_getAssociatedObject(self, &tintAssociationKey);
    return anImageTint;
}

- (void)setImageWithRespectToTint:(UIImage *)image {
    if (self.anImageTint) {
        self.image = [UIImageView anTintImage:image withColor:self.anImageTint];
    }
    else {
        self.image = image;
    }
}

+ (UIImage *)anTintImage:(UIImage *)anImage withColor:(UIColor *)tint {
    if (!tint || !anImage) {
        return anImage;
    }
    CGRect rect = CGRectMake(0, 0, anImage.size.width, anImage.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, anImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [anImage drawInRect:rect];
    CGContextSetFillColorWithColor(context, [tint CGColor]);
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextFillRect(context, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark - Web images & Cache

- (void)setAnImageNameOrUrl:(NSString *)imageNameOrUrl {
    objc_setAssociatedObject(self, &urlAssociationKey, imageNameOrUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    BOOL isScheme = [imageNameOrUrl containsString:@":"];
    if (isScheme) {
        [self anLoadUrlString:imageNameOrUrl];
    }
    else if (imageNameOrUrl) {
        self.imageWithRespectToTint = [UIImage imageNamed:imageNameOrUrl];
    }
    else {
        self.image = nil;
    }
}

- (NSString *)anImageNameOrUrl {
    NSString *imageNameOrUrl = objc_getAssociatedObject(self, &urlAssociationKey);
    return imageNameOrUrl;
}

- (void)anLoadUrlString:(NSString *)urlString {
    UIImage *cached = [[UIImageView anImageCache] objectForKey:urlString];
    if (cached) {
        self.imageWithRespectToTint = cached;
        return;
    }
    self.image = nil;
    [UIImageView imageWithUrl:urlString success:^(UIImage *image) {
        [[UIImageView anImageCache] setObject:image forKey:urlString];
        BOOL imageChangedWhileLoading = self.image != nil;
        BOOL askedToLoadDifferentUrl  = ![self.anImageNameOrUrl isEqualToString:urlString];
        if (imageChangedWhileLoading || askedToLoadDifferentUrl) {
            return;
        }
        self.imageWithRespectToTint = image;
    } failure:^(NSError * _Nonnull error) {}];
}

+ (void)imageWithUrl:(NSString *)urlAsString
             success:(void (^)(UIImage *image))successBlock
             failure:(void (^)(NSError *error))failureBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = nil;
        NSError *error = nil;
        // Avoiding 3rd parties for network calls
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAsString] options:kNilOptions error:&error];
        if (!error) {
            image = [UIImage imageWithData:data];
        }
        if (!error && !image) {
            error = [NSError errorWithDomain:@"com.animaapp.UIImageView"
                                        code:0
                                    userInfo:@{ NSLocalizedDescriptionKey: @"Bad image data" }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failureBlock(error);
            }
            else {
                successBlock(image);
            }
        });
    });
}

+ (NSCache *)anImageCache {
    if (!imageCache) {
        imageCache = [NSCache new];
        imageCache.countLimit = kCacheLimit;
    }
    return imageCache;
}

@end
