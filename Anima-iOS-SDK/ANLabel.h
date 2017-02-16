//
//  ANLabel.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 18/10/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
NS_ASSUME_NONNULL_BEGIN

/** ANLabel gives easier access to text spacing. Its properties are available in storyboard. */
@interface ANLabel : UILabel

/** Text Line height in points. 0 means default */
@property (nonatomic, assign) IBInspectable NSUInteger lineHeight;

/** Text Letter spacing in points. 0 is the default. */
@property (nonatomic, assign) IBInspectable float letterSpacing;

/** Text Paragraph spacing in points. 0 is the default. */
@property (nonatomic, assign) IBInspectable float paragraphSpacing;

@end

NS_ASSUME_NONNULL_END
