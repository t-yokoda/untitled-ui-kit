//
//  ANClassMapping.m
//  Musicapp
//
//  Created by Avishay Cohen on 03/11/2016.
//  Copyright © 2016 Anima App LTD. All rights reserved.
//

#import "ANClassMapping.h"
#import "ANMacros.h"

@interface ANClassMapping ()
@property (nonatomic, strong) NSMutableDictionary *mapping;
@end

@implementation ANClassMapping

+ (instancetype)shared {
    static ANClassMapping *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [ANClassMapping new];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapping = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Mapping

- (void)mapSubclass:(Class)aSubclass forClass:(Class)aClass {
    BOOL isSubclass = [aSubclass isSubclassOfClass:aClass];
    NSString *className = NSStringFromClass(aClass);
    NSString *subclassName = NSStringFromClass(aSubclass);
    if (!isSubclass) {
        ANLog(@"WARN: Bad mapping - '%@' is not subclass of '%@'", subclassName, className);
        return;
    }
    if (className && subclassName) {
        self.mapping[className] = subclassName;
    }
}

- (Class)mappedSubclassFor:(Class)aClass {
    NSString *className = NSStringFromClass(aClass);
    if (!className) {
        return aClass;
    }
    NSString *subclassName = self.mapping[className];
    if (!subclassName) {
        return aClass;
    }
    Class subclass = NSClassFromString(subclassName);
    if (!subclass) {
        return aClass;
    }
    return subclass;
}

- (void)removeMappingForClass:(Class)aClass {
    NSString *className = NSStringFromClass(aClass);
    if (className) {
        [self.mapping removeObjectForKey:className];
    }
}

@end
