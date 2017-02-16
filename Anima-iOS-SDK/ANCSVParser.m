//
//  ANCSVParser.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 21/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANCSVParser.h"

#define kANCSVParserRowsDelimiter  @"\n"
#define kANCSVParserCellsDelimiter @","

@interface ANCSVParser ()
@property (nonatomic, strong) NSMutableArray <NSArray <NSString *>*> *csvRows;
@property (nonatomic, strong) NSError *error;
@end

@implementation ANCSVParser

#pragma mark - Parsing

+ (void)parseCSVWithUrl:(NSURL *)url
                success:(void (^)(NSArray <NSDictionary *> *csvRows))successBlock
                failure:(void (^)(NSError *error))failureBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *csvRows = nil;
        NSError *error = nil;
        // Avoiding 3rd parties for network calls
        NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
        if (!error) {
            csvRows = [ANCSVParser csvRowsWithData:data error:&error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failureBlock(error);
            }
            else {
                successBlock(csvRows);
            }
        });
    });
}

+ (NSArray *)csvRowsWithData:(NSData *)data error:(NSError **)error {
    ANCSVParser *parser = [[ANCSVParser alloc] init];
    NSString *csvString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [parser parseString:csvString];
    if (nil != error &&
        nil != parser.error) {
        *error = parser.error;
    }
    return parser.csvRows;
}

- (void)parseString:(NSString *)csvString {
    self.csvRows = [NSMutableArray new];
    NSArray *rawRows = [csvString componentsSeparatedByString:kANCSVParserRowsDelimiter];
    for (NSString *rowAsString in rawRows) {
        NSString *cleanRowString = [rowAsString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSArray *rowItems = [cleanRowString componentsSeparatedByString:kANCSVParserCellsDelimiter];
        NSMutableArray *parsedRow = [NSMutableArray new];
        for (NSString *possiblyWrappedValue in rowItems) {
            [parsedRow addObject:[self unwrapCSVString:possiblyWrappedValue]];
        }
        [self.csvRows addObject:parsedRow];
    }
}

- (NSString *)unwrapCSVString:(NSString *)csvString {
    if ([csvString hasPrefix:@"\""] &&
        [csvString hasSuffix:@"\""] &&
        csvString.length >= 2) {
        NSString *unwrappedString = [csvString substringWithRange:NSMakeRange(1, csvString.length-2)];
        unwrappedString = [unwrappedString stringByReplacingOccurrencesOfString:@"\"\"" withString:@"\""];
        return unwrappedString;
    }
    else {
        return csvString;
    }
}

@end
