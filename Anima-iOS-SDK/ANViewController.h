//
//  ANViewController.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 10/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANProtocols.h"

/** ANViewController adds some functionallity to NSViewController */
@interface ANViewController : UIViewController <ANCustomViewDelegate>

@property (nonatomic, assign) IBInspectable BOOL hidesNavBar;
@property (nonatomic, assign) IBInspectable BOOL hidesStatusBar;
@property (nonatomic, assign) IBInspectable BOOL lightStatusBar;

- (void)hideNavigationBar:(BOOL)hide animated:(BOOL)animated;
- (void)dismiss:(BOOL)animated;

@end
