//
//  MKMapView+Anima.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <MapKit/MKMapView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMapView (Anima)

/** Setting load the address async */
@property (nonatomic, strong, nullable) IBInspectable NSString *anAddress;

/** Will load the adress async */
- (void)anLoadAddress:(nonnull NSString *)address
              success:(nullable void (^)(CLPlacemark * _Nullable aPlacemark))successBlock
              failure:(nullable void (^)(NSError * _Nullable error))failureBlock;
@end

NS_ASSUME_NONNULL_END