//
//  ANProtocols.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 25/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ANCustomViewDelegate <NSObject>

- (void)view:(UIView *)aView shouldPushViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;
- (void)view:(UIView *)aView shouldPresentViewControllerWithIdentifier:(NSString *)identifier animated:(BOOL)animated;
- (void)view:(UIView *)aView shouldDismissScreenAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END