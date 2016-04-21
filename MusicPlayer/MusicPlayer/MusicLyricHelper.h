//
//  MusicLyricHelper.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/20.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyricMedel.h"

@interface MusicLyricHelper : NSObject

#pragma mark --- 获取歌词工具对象
+(instancetype)sharedMusicLyricHelper;

#pragma mark --- 解析歌词,并封装成model对象
- (void)parseLyricWithLyricString:(NSString *)lyricString;

@property (nonatomic, assign) NSInteger count;  // 获取model对象的个数

#pragma mark --- 根据传过来的indexPath获取model对象
- (LyricMedel *)lyricWithIndexPath:(NSIndexPath *)indexPath;

#pragma mark --- 根据时间获取下标
- (NSInteger)getIndexWithTime:(NSTimeInterval)time;


@end
