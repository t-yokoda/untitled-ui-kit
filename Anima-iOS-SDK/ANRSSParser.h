//
//  ANRSSParser.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 21/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kANRSSParserKeyGuid                 @"guid"
#define kANRSSParserKeyTitle                @"title"
#define kANRSSParserKeyLink                 @"link"
#define kANRSSParserKeyDescriptionOrContent @"description"
#define kANRSSParserKeyRSSDescription       @"rssDescription"
#define kANRSSParserKeyRSSContent           @"rssContent"
#define kANRSSParserKeyRSSContentEncoded    @"rssContentEncoded"
#define kANRSSParserKeyImage                @"image"
#define kANRSSParserKeyImages               @"images"
#define kANRSSParserKeyAuthor               @"author"
#define kANRSSParserKeyPublishDateTimeAgo   @"publishDateTimeAgo"
#define kANRSSParserKeyPublishDate          @"publishNSDate"          //NSDate
#define kANRSSParserKeyCommentsCount        @"commentsCount"
#define kANRSSParserKeyLanguage             @"language"

NS_ASSUME_NONNULL_BEGIN

/** Basic RSS Parer */
@interface ANRSSParser : NSObject

/** Async call to fetch and parse rss items from remote/local URL */
+ (void)parseRSSWithUrl:(NSURL *)url
                success:(void (^)(NSArray <NSDictionary *> *rssItems))successBlock
                failure:(void (^)(NSError *error))failureBlock;

/** Sync call to parse rss items from XML UTF8 data */
+ (NSArray *)rssItemsFromXML:(NSData *)xmlUtf8 error:(NSError **)error;

@end
NS_ASSUME_NONNULL_END