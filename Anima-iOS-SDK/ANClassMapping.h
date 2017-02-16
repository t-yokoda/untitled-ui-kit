//
//  ANClassMapping.h
//  Musicapp
//
//  Created by Avishay Cohen on 03/11/2016.
//  Copyright © 2016 Anima App LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

/** ANClassMapping is used to swap a class with one of its subclasses on runtime, durinc 'alloc'. 
    An easy way to inject different implementations for View Controllers when instantiated from a storyboard. 
    You'd need to override alloc if it's not Anima's ViewController. **/

@interface ANClassMapping : NSObject

+ (instancetype)shared;

/** When 'Class' is allocated / instantiated, an instance of 'Subclass' is returned. **/
- (void)mapSubclass:(Class)aSubclass forClass:(Class)aClass;

- (Class)mappedSubclassFor:(Class)aClass;
- (void)removeMappingForClass:(Class)aClass;

@end


/* Usage: In order to use mapping in a custom class, override alloc:

 + (instancetype)alloc {
    Class mappedClass = [[ANClassMapping shared] mappedSubclassFor:self];
    if (self == mappedClass) {
        return [super alloc];
    }
    else {
        return [mappedClass alloc];
    }
 }

*/
