//
//  UIWebView+Anima.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWebView (Anima)
@property (nonatomic, strong, nullable) IBInspectable NSString *anUrl;
- (void)anLoadUrlString:(nonnull NSString *)urlString;
@end
