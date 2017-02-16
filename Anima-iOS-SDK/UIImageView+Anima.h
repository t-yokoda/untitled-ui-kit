//
//  UIImageView+Anima.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 22/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Holds a cache for web images and convinience methods */
@interface UIImageView (Anima)

/** Color overlay image with transparancy. Affects current image & images set using anImageNameOrUrl */
@property (nonatomic, copy, nullable) IBInspectable UIColor *anImageTint;

- (void)setImageWithRespectToTint:(UIImage *)image;

/** Accepts both string URLs or xcassets image names */
@property (nonatomic, copy, nullable) IBInspectable NSString *anImageNameOrUrl;

/** Returns cached or fetches if not in cache */
+ (void)imageWithUrl:(NSString *)urlAsString
             success:(void (^)(UIImage *image))successBlock
             failure:(void (^)(NSError *error))failureBlock;

+ (UIImage *)anTintImage:(UIImage *)anImage withColor:(UIColor *)tint;
@end

NS_ASSUME_NONNULL_END