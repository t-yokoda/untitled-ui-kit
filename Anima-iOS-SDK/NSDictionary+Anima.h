//
//  NSDictionary+Anima.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 30/09/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Anima)

/** Easy access to nested Dictionaries & Arrays. i.e. 'results.items[0].title' */
- (nullable id)an_objectForJsonPath:(NSString *)aPath;

@end

NS_ASSUME_NONNULL_END
