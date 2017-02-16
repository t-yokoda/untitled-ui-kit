//
//  ANCSVParser.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 21/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** Basic CSV Parer */
@interface ANCSVParser : NSObject

/** Async call to fetch and parse csv items from remote/local URL */
+ (void)parseCSVWithUrl:(NSURL *)url
                success:(void (^)(NSArray <NSDictionary *> *csvRows))successBlock
                failure:(void (^)(NSError *error))failureBlock;

/** Sync call to parse csv from UTF8 data */
+ (NSArray *)csvRowsWithData:(NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END