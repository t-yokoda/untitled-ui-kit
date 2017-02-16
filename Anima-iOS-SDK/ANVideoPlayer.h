//
//  ANVideoPlayer.h
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ANVideoPlayerDelegate;

IB_DESIGNABLE

/** ANVideoPlayer gives easier access to AVPlayer. Its propertiesa are available in storyboard. */
@interface ANVideoPlayer : UIView

@property (nonatomic, weak, nullable) IBOutlet id<ANVideoPlayerDelegate> delegate;

@property (nonatomic, assign) IBInspectable BOOL autoplay;
@property (nonatomic, assign) IBInspectable BOOL loop;
@property (nonatomic, assign) IBInspectable BOOL showControls;

/** Accepts both string URLs or bundle file names */
@property (nonatomic, copy, nullable) IBInspectable NSString *videoFileOrUrl;

- (nullable AVPlayerViewController *)playerVC;
- (nullable UIView *)playerView;
@end


NS_ASSUME_NONNULL_BEGIN
@protocol ANVideoPlayerDelegate <NSObject>

@optional
- (void)videoPlayer:(ANVideoPlayer *)videoPlayer willLoadUrl:(NSURL *)url;
- (void)videoPlayerDidPlayToEnd:(ANVideoPlayer *)videoPlayer;

@end
NS_ASSUME_NONNULL_END