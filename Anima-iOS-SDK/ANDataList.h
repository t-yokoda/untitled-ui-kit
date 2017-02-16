//
//  ADDataList.h
//  AppDesigner
//
//  Created by Avishay Cohen on 01/03/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ANDataList;

typedef enum {
    ANDataTypeCSV,
    ANDataTypeJSON,
    ANDataTypeRSS,
} ANDataType;

NS_ASSUME_NONNULL_BEGIN

@protocol ANDataListDelegate <NSObject>
@optional
- (void)dataListDidStartLoading:(ANDataList *)dataList;
- (void)dataListDidFinishLoading:(ANDataList *)dataList;
- (void)dataList:(ANDataList *)dataList didFailLoadingWithError:(NSError *)error;
@end

/** ANDataList is a fast way to to fetch and parse common data formats: Json, RSS, CSV */
@interface ANDataList : NSObject
@property (nonatomic, weak, nullable) id<ANDataListDelegate>    delegate;
@property (nonatomic, assign)         ANDataType                dataType;
@property (nonatomic, copy, nullable) NSString                  *filenameOrUrl;
@property (nonatomic, copy, nullable) NSString                  *jsonPathToList;

+ (instancetype)dataListWithType:(ANDataType)dataType filenameOrUrl:(NSString *)filenameOrUrl delegate:(id<ANDataListDelegate>)delegate;
- (void)refresh;
- (BOOL)isLoading;
- (NSArray <NSDictionary *> *)items;
- (NSUInteger)count;
- (nullable NSDictionary *)itemAtIndex:(NSUInteger)index;

@end
NS_ASSUME_NONNULL_END
