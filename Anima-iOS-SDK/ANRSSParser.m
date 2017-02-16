//
//  ANRSSParser.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 21/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANRSSParser.h"

@interface ANRSSParser () <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray <NSDictionary *>   *rssItems;
@property (nonatomic, strong) NSError                           *error;
@property (nonatomic, strong) NSMutableDictionary               *currentItem;
@property (nonatomic, strong) NSMutableString                   *currentStringValue;
@property (nonatomic, strong) NSMutableDictionary               *currentChannel;
@end

@implementation ANRSSParser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rssItems = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Parsing

+ (void)parseRSSWithUrl:(NSURL *)url
                success:(void (^)(NSArray <NSDictionary *> *rssItems))successBlock
                failure:(void (^)(NSError *error))failureBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *rssItems = nil;
        NSError *error = nil;
        // Avoiding 3rd parties for network calls
        NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
        if (!error) {
            rssItems = [ANRSSParser rssItemsFromXML:data error:&error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                failureBlock(error);
            }
            else {
                successBlock(rssItems);
            }
        });
    });
}

+ (NSArray *)rssItemsFromXML:(NSData *)xmlUtf8 error:(NSError **)error {
    ANRSSParser *parser = [[ANRSSParser alloc] init];
    [parser parseRSS:xmlUtf8];
    if (nil != error &&
        nil != parser.error) {
        *error = parser.error;
    }
    return parser.rssItems;
}

- (void)parseRSS:(NSData *)xmlUtf8 {
    self.rssItems = [NSMutableArray array];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlUtf8];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    for (NSMutableDictionary *item in self.rssItems) {
        [self fillDerivedFields:item];
    }
}

#pragma mark - Mapping

+ (NSDictionary *)rssMapping {
    static NSDictionary *mapping = nil;
    if (!mapping) {
        mapping = @{
                    @"guid": kANRSSParserKeyGuid,
                    @"title": kANRSSParserKeyTitle,
                    @"link": kANRSSParserKeyLink,
                    @"description": kANRSSParserKeyRSSDescription,
                    @"content": kANRSSParserKeyRSSContent,
                    @"content:encoded": kANRSSParserKeyRSSContentEncoded,
                    @"dc:creator": kANRSSParserKeyAuthor,
                    @"slash:comments": kANRSSParserKeyCommentsCount,
                    };
    }
    return mapping;
}

+ (NSArray *)supportedItemFields {
    static NSArray *fields = nil;
    if (!fields) {
        fields = @[ @"guid", @"title", @"link", @"description", @"content", @"content:encoded", @"dc:creator", @"slash:comments", @"category", @"pubDate", @"language"];
    }
    return fields;
}

#pragma mark - NSXMLParserDelegate

// Attribute starts
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"item"]) {
        self.currentItem = [NSMutableDictionary dictionary];
    }
    if ([elementName isEqualToString:@"channel"]) {
        self.currentChannel = [NSMutableDictionary dictionary];
    }
    else if ([[ANRSSParser supportedItemFields] containsObject:elementName]) {
        self.currentStringValue = [NSMutableString string];
    }
}

// Attribute ends
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"] &&
        self.currentItem != nil) {
        if (self.currentChannel != nil) {
            self.currentItem[@"channel"] = self.currentChannel;
        }
        [self.rssItems addObject:self.currentItem];
        self.currentItem = nil;
    }
    else if ([[ANRSSParser supportedItemFields] containsObject:elementName]) {
        if ([self.currentStringValue length] > 0) {
            NSString *mappedKey = [ANRSSParser rssMapping][elementName] ?: elementName;
            if (self.currentItem) {
                self.currentItem[mappedKey] = [self.currentStringValue copy];
            }
            else if (self.currentChannel) {
                self.currentChannel[mappedKey] = [self.currentStringValue copy];
            }
        }
    }
    if ([elementName isEqualToString:@"channel"]) {
        self.currentChannel = nil;
    }
}

// String text - between attributes
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    self.error = parseError;
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    self.error = validationError;
}

#pragma mark - Derived Fields

- (void)fillDerivedFields:(NSMutableDictionary *)item {
    [ANRSSParser updateItemDictionaryWithDate:item];
    [ANRSSParser updateItemDictionaryWithImages:item];
    if (item[kANRSSParserKeyRSSDescription]) {
        item[kANRSSParserKeyDescriptionOrContent] = item[kANRSSParserKeyRSSDescription];
    }
    else if (item[kANRSSParserKeyRSSContent]) {
        item[kANRSSParserKeyDescriptionOrContent] = item[kANRSSParserKeyRSSContent];
    }
}

+ (void)updateItemDictionaryWithDate:(NSMutableDictionary *)item {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    }
    NSString *dateString = [item[@"pubDate"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    dateString = [[NSString alloc] initWithData:[dateString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
                                       encoding:NSASCIIStringEncoding];
    NSDate *date = [dateFormatter dateFromString:dateString];
    if (date) {
        item[kANRSSParserKeyPublishDate] = date;
    }
}

+ (void)updateItemDictionaryWithImages:(NSMutableDictionary *)item {
    NSArray *links = [self extractImageLinks:item[kANRSSParserKeyRSSDescription]] ?: @[];
    links = [links arrayByAddingObjectsFromArray:[self extractImageLinks:item[kANRSSParserKeyRSSContent]]];
    links = [links arrayByAddingObjectsFromArray:[self extractImageLinks:item[kANRSSParserKeyRSSContentEncoded]]];
    item[kANRSSParserKeyImages] = links;
    if (links.count > 0) {
        item[kANRSSParserKeyImage] = links[0];
    }
}

+ (NSArray *)extractImageLinks:(NSString *)text {
    if (!text) {
        return @[];
    }
    NSMutableArray *res = [NSMutableArray new];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"https?:[^\"']+\\.(png|jpg|jpeg|gif)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    [regex enumerateMatchesInString:text
                            options:0
                              range:NSMakeRange(0, text.length)
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSString *link = [text substringWithRange:result.range];
                             [res addObject:link];
                         }];
    return res;
}

@end
