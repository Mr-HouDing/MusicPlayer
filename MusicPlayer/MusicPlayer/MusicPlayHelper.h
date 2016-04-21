//
//  MusicPlayHelper.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/16.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <Foundation/Foundation.h>

// 声明协议
@protocol MusicPlayHelperDelegate <NSObject>

// 正在播放音乐
- (void)playingToTime:(NSTimeInterval)time;

// 音乐播放结束
- (void)playingDidEnd;

@end

@interface MusicPlayHelper : NSObject

@property (nonatomic, assign) BOOL isPlaying;   // 存储播放状态

@property (nonatomic, assign) id<MusicPlayHelperDelegate> delegate;

#pragma mark --- 获取播放音乐的单例对象
+ (instancetype)sharedMusicPlayHelper;

#pragma mark --- 根据传过来的MP3Url, 来进行播放音乐
- (void)preparePlayingMusicWithUrlString:(NSString *)urlString;


#pragma mark --- 播放功能
- (void)play;

#pragma mark --- 暂停功能
- (void)pause;

#pragma mark --- 根据指定的时间播放歌曲
- (void)seekToPlayWithTime:(NSTimeInterval)time;

#pragma maek --- 设置音量
@property (nonatomic, assign) float volume;


@end
