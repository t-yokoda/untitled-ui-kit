//
//  NSString+Anima.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 30/09/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Anima)

/** Break a path phrase into path components.\n\r
  * Special chars: '\\.[]'.\n\r
  * Escaping using '\\'.\n\r
  * i.e. @"one.two[3]" -> @[@"one", @"two", @3] */
- (NSArray *)an_jsonPathComponents;

@end

NS_ASSUME_NONNULL_END
