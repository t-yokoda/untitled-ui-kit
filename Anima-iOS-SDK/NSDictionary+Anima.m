//
//  NSDictionary+Anima.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 30/09/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "NSDictionary+Anima.h"
#import "NSString+Anima.h"

@implementation NSDictionary (Anima)

- (id)an_objectForJsonPath:(NSString *)aPath {
    NSArray *pathComponents = [aPath an_jsonPathComponents];
    id res = self;
    while (res && pathComponents.count > 0) {
        BOOL isDictionary = [res isKindOfClass:[NSDictionary class]];
        BOOL isArray = [res isKindOfClass:[NSArray class]];
        BOOL supportedClassForPath = (isArray || isDictionary);
        if (!supportedClassForPath) {
            return nil; // Not supported and still has a path component
        }
        if (isDictionary) {
            res = res[pathComponents[0]];
        }
        else if (isArray && [res count] > [pathComponents[0] unsignedIntegerValue]) {
            res = res[[pathComponents[0] unsignedIntegerValue]];
        }
        else {
            return nil; // Index out of bounds
        }
        pathComponents = [pathComponents subarrayWithRange:NSMakeRange(1, pathComponents.count - 1)];
    }
    return res;
}

@end
