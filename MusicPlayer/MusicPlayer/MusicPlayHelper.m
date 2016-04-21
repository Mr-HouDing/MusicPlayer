//
//  MusicPlayHelper.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/16.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicPlayHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayHelper ()

@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, strong) NSTimer *timer; // 定时器, 用来将歌曲播放的时间不断地传给播放列表页面, 给timeSlider赋值

@end

@implementation MusicPlayHelper

#pragma mark --- 获取播放音乐的单例对象
+ (instancetype)sharedMusicPlayHelper
{
    static MusicPlayHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MusicPlayHelper alloc] init];
    });
    return helper;
}

// 使用懒加载创建avPlayer对象
- (AVPlayer *)avPlayer
{
    if (!_avPlayer)
    {
        _avPlayer = [[AVPlayer alloc] init];
    }
    return _avPlayer;
}

#pragma mark --- 根据传过来的MP3Url, 来进行播放音乐
- (void)preparePlayingMusicWithUrlString:(NSString *)urlString
{
    // 根据urlString创建,avPlayer要不播放的AVPlayerItem
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.avPlayer replaceCurrentItemWithPlayerItem:item];
    
    // 使用KVO观察avPlayer有没有准备完毕
    [self.avPlayer addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay)
    {
        [self play];
    }
}

#pragma mark --- 播放功能
- (void)play
{
    if (self.isPlaying == YES)
    {
        return;
    }
    [self.avPlayer play];
    self.isPlaying = YES;
    
    if (self.timer)
    {
        return;
    }
    // 当歌曲一开始就创建定时器(每0.01秒,执行后面的方法)
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(playAction:) userInfo:nil repeats:YES];
}

- (void)playAction:(NSTimer *)timer
{
    NSTimeInterval seconds = self.avPlayer.currentTime.value / self.avPlayer.currentTime.timescale;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playingToTime:)])
    {
        [self.delegate playingToTime:seconds];
    }
}

#pragma mark --- 暂停功能
- (void)pause
{
    if (self.isPlaying == NO)
    {
        return;
    }
    [self.avPlayer pause];
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark --- 根据指定的时间播放歌曲
- (void)seekToPlayWithTime:(NSTimeInterval)time
{
//    // 公式: value/timescale = seconds
//    [self.avPlayer seekToTime:CMTimeMake(time * self.avPlayer.currentTime.timescale, self.avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
//        
//    }];
    
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(time, self.avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
        
    }];
}

#pragma mark --- 设置音量, 通过重写方法
- (void)setVolume:(float)volume
{
    self.avPlayer.volume = volume;
}

#pragma mark --- 使用通知观察当前歌曲是否播放完毕
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 通知中心
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)playDidEnd
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playingDidEnd)])
    {
        [self.delegate playingDidEnd];
    }
}

@end
