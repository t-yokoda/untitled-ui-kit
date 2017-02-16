//
//  NSString+Anima.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 30/09/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "NSString+Anima.h"

@implementation NSString (Anima)

- (NSArray *)an_jsonPathComponents {
    static NSMutableCharacterSet *specialCharSet = nil;
    if (!specialCharSet) {
        specialCharSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"\\.[]"];
    }
    NSScanner *stringScanner = [NSScanner scannerWithString:self];
    stringScanner.charactersToBeSkipped = specialCharSet;
    NSMutableArray *res = [NSMutableArray array];
    NSString *pathComponent = nil;
    BOOL shouldContinuePrevConponent = NO;
    
    BOOL firstRoundWithSpecials = [self hasPrefix:@"\\"];
    if (firstRoundWithSpecials) {
        [res addObject:@""]; // Edge case
    }
    
    while (firstRoundWithSpecials || [stringScanner scanUpToCharactersFromSet:specialCharSet intoString:&pathComponent]) {
        firstRoundWithSpecials = NO;
        
        // Add / Append component
        if (pathComponent.length > 0 && shouldContinuePrevConponent) {
            res[res.count-1] = [res.lastObject stringByAppendingString:pathComponent];
        }
        else if (pathComponent.length > 0) {
            [res addObject:pathComponent];
        }
        if (stringScanner.scanLocation == stringScanner.string.length) {
            break;
        }
        
        // Special Chars
        BOOL readingSpecials = YES;
        shouldContinuePrevConponent = YES;
        while (readingSpecials && stringScanner.scanLocation < stringScanner.string.length) {
            unichar nextChar = [stringScanner.string characterAtIndex:stringScanner.scanLocation];
            switch (nextChar) {
                case '.':
                    shouldContinuePrevConponent = NO;
                    stringScanner.scanLocation++;
                    break;
                case '\\': {
                    unichar escapedChar = [stringScanner.string characterAtIndex:stringScanner.scanLocation + 1];
                    NSString *escapedCharString = [NSString stringWithCharacters:&escapedChar length:1];
                    if (shouldContinuePrevConponent) {
                        res[res.count-1] = [res.lastObject stringByAppendingString:escapedCharString];
                    }
                    else {
                        [res addObject:escapedCharString];
                    }
                    stringScanner.scanLocation += 2;
                    shouldContinuePrevConponent = YES;
                    break;
                }
                case '[': {
                    NSInteger pathIndexComponent = 0;
                    [stringScanner scanInteger:&pathIndexComponent];
                    [res addObject:@(pathIndexComponent)];
                    shouldContinuePrevConponent = NO;
                    break;
                }
                case ']':
                    // Skip
                    stringScanner.scanLocation++;
                    break;
                default:
                    readingSpecials = NO;
                    break;
            }
            if (stringScanner.scanLocation == stringScanner.string.length) {
                readingSpecials = NO;
            }
        }
    }
    return res;
}

@end
