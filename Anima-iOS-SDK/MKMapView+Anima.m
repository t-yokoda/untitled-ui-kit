//
//  MKMapView+Anima.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "MKMapView+Anima.h"
#import <objc/runtime.h>

static void *mapAddressAssociationKey;

@implementation MKMapView (Anima)

- (void)setAnAddress:(NSString *)anAddress {
    objc_setAssociatedObject(self, &mapAddressAssociationKey, anAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (anAddress) {
        [self anLoadAddress:anAddress success:nil failure:nil];
    }
}

- (NSString *)anAddress {
    NSString *address = objc_getAssociatedObject(self, &mapAddressAssociationKey);
    return address;
}

- (void)anLoadAddress:(nonnull NSString *)address
              success:(void (^)(CLPlacemark * _Nullable aPlacemark))successBlock
              failure:(void (^)(NSError * _Nullable error))failureBlock {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        CLPlacemark *aPlacemark = placemarks.count > 0 ? placemarks.lastObject : nil;
        if (!aPlacemark) {
            if (failureBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(error);
                });
            }
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            float spanFromRadius = 0.05;
            if ([aPlacemark.region isKindOfClass:[CLCircularRegion class]]) {
                spanFromRadius = ((CLCircularRegion *)aPlacemark.region).radius / 112000.0;
            }
            [self setRegion:MKCoordinateRegionMake(aPlacemark.location.coordinate,
                                                   MKCoordinateSpanMake(spanFromRadius, spanFromRadius)) animated:NO];
            if (successBlock) {
                successBlock(aPlacemark);
            }
        });
    }];
}

@end
