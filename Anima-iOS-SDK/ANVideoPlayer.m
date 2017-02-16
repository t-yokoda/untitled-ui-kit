//
//  ANVideoPlayer.m
//  Anima-iOS-SDK
//
//  Created by Avishay Cohen on 07/08/2016.
//  Copyright © 2016 AnimaApp.com. All rights reserved.
//

#import "ANVideoPlayer.h"
#import "ANMacros.h"

@interface ANVideoPlayer ()
@property (nonatomic, strong, nullable) AVPlayerViewController *playerVC;
@property (nonatomic, strong, nullable) UIView                 *playerView;
@property (nonatomic, assign) BOOL didAwakeFromNib;
@end

@implementation ANVideoPlayer

- (void)awakeFromNib {
    [super awakeFromNib];
    self.didAwakeFromNib = YES;
    if (self.videoFileOrUrl) {
        [self loadUrl:self.videoFileOrUrl];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    AN_INTERFACE_BUILDER_TITLE(@"Video Player")
}

#pragma mark - Load video

- (void)setVideoFileOrUrl:(NSString *)videoFileOrUrl {
    if (![_videoFileOrUrl isEqualToString:videoFileOrUrl]) {
        _videoFileOrUrl = videoFileOrUrl;
    }
    if (videoFileOrUrl && self.didAwakeFromNib) {
        [self loadUrl:videoFileOrUrl];
    }
}

- (void)loadUrl:(NSString *)urlString {
    NSURL *url = nil;
    BOOL isScheme = [urlString containsString:@":"];
    BOOL isLocalFile = !isScheme && urlString.length > 0;
    if (isScheme) {
        url = [NSURL URLWithString:urlString];
    }
    else if (isLocalFile) {
        NSString *fileExtention = [urlString pathExtension];
        NSString *fileName = [urlString stringByDeletingPathExtension];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtention];
        url = filePath ? [NSURL fileURLWithPath:filePath] : nil;
    }
    if (!url) {
        return;
    }
    _videoFileOrUrl = urlString;
    [self.playerView removeFromSuperview];
    [self.playerVC.player pause];
    self.playerVC = [[AVPlayerViewController alloc] init];
    self.playerVC.player = [AVPlayer playerWithURL:url];
    self.playerView = self.playerVC.view;
    self.playerView.frame = self.bounds;
    [self addSubview:self.playerView];
    if (self.autoplay) {
        [self.playerVC.player play];
    }
    self.playerVC.showsPlaybackControls = self.showControls;
    if (self.loop) {
        [self loopVideo];
    }
    else {
        [self stopLooping];
    }
    if ([self.delegate respondsToSelector:@selector(videoPlayer:willLoadUrl:)]) {
        [self.delegate videoPlayer:self willLoadUrl:url];
    }
}

#pragma mark - Loop

- (void)loopVideo {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)stopLooping {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)didPlayToEnd:(NSNotification *)notification {
    if (self.playerVC.player.currentItem != notification.object) {
        return;
    }
    if (self.loop) {
        [self.playerVC.player seekToTime:CMTimeMake(0, 1000)];
        [self.playerVC.player play];
    }
    else {
        [self stopLooping];
        if ([self.delegate respondsToSelector:@selector(videoPlayerDidPlayToEnd:)]) {
            [self.delegate videoPlayerDidPlayToEnd:self];
        }
    }
}

@end