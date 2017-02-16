//
//  ADDataList.m
//  AppDesigner
//
//  Created by Avishay Cohen on 01/03/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANDataList.h"
#import "ANRSSParser.h"
#import "ANCSVParser.h"
#import "NSDictionary+Anima.h"

#define WrapJsonObjectAsDictionary(obj)  (@{ @"value" : (obj) })

@interface ANDataList ()
@property (nonatomic, strong) NSArray <NSDictionary *>  *items;
@property (nonatomic, assign) BOOL                      isLoading;
@end

@implementation ANDataList

+ (instancetype)dataListWithType:(ANDataType)dataType filenameOrUrl:(NSString *)filenameOrUrl delegate:(id<ANDataListDelegate>)delegate {
    ANDataList *dataList = [ANDataList new];
    dataList.dataType = dataType;
    dataList.filenameOrUrl = filenameOrUrl;
    dataList.delegate = delegate;
    return dataList;
}

- (NSUInteger)count {
    return self.items.count;
}

- (nullable NSDictionary *)itemAtIndex:(NSUInteger)index {
    if (self.items.count <= index) {
        return nil;
    }
    return self.items[index];
}

- (void)refresh {
    switch (self.dataType) {
        case ANDataTypeRSS:
            [self refreshRSS];
            break;
        case ANDataTypeCSV:
            [self refreshCSV];
            break;
        case ANDataTypeJSON:
            [self refreshJson];
            break;
        default:
            break;
    }
}

- (NSURL *)dataUrl {
    NSURL *url = nil;
    BOOL isLink = ([self.filenameOrUrl.lowercaseString hasPrefix:@"http://"] ||
                   [self.filenameOrUrl.lowercaseString hasPrefix:@"https://"]);
    if (isLink) {
        url = [NSURL URLWithString:self.filenameOrUrl];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[self.filenameOrUrl stringByDeletingPathExtension] ofType:[self.filenameOrUrl pathExtension]];
        url = [NSURL fileURLWithPath:path];
    }
    return url;
}

#pragma mark - Events

- (void)didStartLoading {
    if ([self.delegate respondsToSelector:@selector(dataListDidStartLoading:)]) {
        [self.delegate dataListDidStartLoading:self];
    }
}

- (void)didFinishLoading {
    if ([self.delegate respondsToSelector:@selector(dataListDidFinishLoading:)]) {
        [self.delegate dataListDidFinishLoading:self];
    }
}

- (void)didFailLoadingWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(dataList:didFailLoadingWithError:)]) {
        [self.delegate dataList:self didFailLoadingWithError:error];
    }
}

#pragma mark - RSS

- (void)refreshRSS {
    self.isLoading = YES;
    [self didStartLoading];
    NSURL *rssURL = [self dataUrl];
    [ANRSSParser parseRSSWithUrl:rssURL success:^(NSArray<NSDictionary *> * _Nonnull rssItems) {
        self.items = rssItems;
        self.isLoading = NO;
        [self didFinishLoading];
    } failure:^(NSError *error) {
        self.isLoading = NO;
        [self didFailLoadingWithError:error];
    }];
}

#pragma mark - CSV

- (void)refreshCSV {
    self.isLoading = YES;
    self.items = @[];
    [self didStartLoading];
    NSURL *csvURL = [self dataUrl];
    [ANCSVParser parseCSVWithUrl:csvURL success:^(NSArray<NSDictionary *> * _Nonnull csvRows) {
        self.items = [self itemsFromCSVRows:csvRows];
        self.isLoading = NO;
        [self didFinishLoading];
    } failure:^(NSError *error) {
        self.isLoading = NO;
        [self didFailLoadingWithError:error];
    }];
}

- (NSArray *)itemsFromCSVRows:(NSArray *)lines {
    NSMutableArray *csvItemsAsDictionaries = [NSMutableArray array];
    for (int lineIndex = 1; lineIndex < lines.count; lineIndex++) {
        NSMutableDictionary *item = [NSMutableDictionary new];
        for (int fieldIndex = 0; fieldIndex < [lines[0] count]; fieldIndex++) {
            if ([lines[0][fieldIndex] length] == 0) {
                continue;
            }
            item[lines[0][fieldIndex]] = [lines[lineIndex] count] > fieldIndex ? lines[lineIndex][fieldIndex] : @"";
        }
        [csvItemsAsDictionaries addObject:item];
    }
    return csvItemsAsDictionaries;
}

#pragma mark - Json

- (void)refreshJson {
    self.isLoading = YES;
    self.items = @[];
    [self didStartLoading];
    NSURL *jsonURL = [self dataUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL options:kNilOptions error:&error];
        NSArray *resItems = nil;
        if (!error) {
            resItems = [self itemsFromJsonData:jsonData error:&error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.items = resItems;
            self.isLoading = NO;
            if (error) {
                [self didFailLoadingWithError:error];
            }
            else {
                [self didFinishLoading];
            }
        });
    });
}

- (NSArray *)itemsFromJsonData:(NSData *)jsonData error:(NSError **)errorPtr {
    if (!jsonData) {
        return @[];
    }
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error || !jsonObject) {
        if (errorPtr) {
            *errorPtr = error;
        }
        return @[];
    }
    
    NS_DURING
    if (self.jsonPathToList.length > 0) {
        jsonObject = [jsonObject an_objectForJsonPath:self.jsonPathToList];
    }
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        return @[jsonObject];
    }
    else if ([jsonObject isKindOfClass:[NSArray class]]) {
        return [self jsonArrayToItemsArray:jsonObject];
    }
    else {
        return @[WrapJsonObjectAsDictionary(jsonObject)];
    }
    NS_HANDLER
    NSString *message = [@"Failed parsing json: " stringByAppendingString:localException.description];
    *errorPtr = [NSError errorWithDomain:@"com.animaapp.ANData" code:0 userInfo:@{ NSLocalizedDescriptionKey: message }];
    return @[];
    NS_ENDHANDLER
}

- (NSArray *)jsonArrayToItemsArray:(NSArray *)jsonArray {
    NSMutableArray *res = [NSMutableArray new];
    for (id item in jsonArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            [res addObject:item];
        }
        else  {
            [res addObject:WrapJsonObjectAsDictionary([item description])];
        }
    }
    return res;
}

@end
