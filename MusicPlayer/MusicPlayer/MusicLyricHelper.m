//
//  MusicLyricHelper.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/20.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicLyricHelper.h"
#import "LyricMedel.h"
#import <UIKit/UIKit.h>

@interface MusicLyricHelper ()

@property (nonatomic, strong) NSMutableArray *allLyricModelArray; // 存放所有歌词对象的数组

@end


@implementation MusicLyricHelper

#pragma mark --- 获取歌词工具对象
+(instancetype)sharedMusicLyricHelper
{
    static MusicLyricHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MusicLyricHelper alloc] init];
    });
    return helper;
}

#pragma mark --- 解析歌词,并封装成model对象
- (void)parseLyricWithLyricString:(NSString *)lyricString
{
    
    // 当切换新歌的时候, 将数组中原来的歌词对象清空
    [self.allLyricModelArray removeAllObjects];
    

    NSArray *array = [lyricString componentsSeparatedByString:@"\n"];

    for (NSString *string in array)
    {
        NSArray *timeStrAndLyricStr =[string componentsSeparatedByString:@"]"];

        if ([timeStrAndLyricStr.firstObject length] == 0)
        {
            continue;   // 结束本次循环
        }
        NSString *str = timeStrAndLyricStr.firstObject;
        NSString *timeStr = [str substringFromIndex:1];
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        
        // 计算秒数
        NSTimeInterval seconds = [timeArray.firstObject doubleValue] * 60 + [timeArray.lastObject doubleValue];
        // 每一句歌词
        NSString *lyricStr = [timeStrAndLyricStr lastObject];
        
        // 创建model对象
        LyricMedel *lyric = [[LyricMedel alloc] initWithTime:seconds lyricString:lyricStr];
        [self.allLyricModelArray addObject:lyric];
    }
    
}

// 使用懒加载创建并初始化数组
- (NSMutableArray *)allLyricModelArray
{
    if (!_allLyricModelArray)
    {
        _allLyricModelArray = [NSMutableArray array];
    }
    return _allLyricModelArray;
}

- (NSInteger)count
{
    return self.allLyricModelArray.count;
}

#pragma mark --- 根据传过来的indexPath获取model对象
- (LyricMedel *)lyricWithIndexPath:(NSIndexPath *)indexPath
{
    return self.allLyricModelArray[indexPath.row];
}

#pragma mark --- 根据时间获取下标
- (NSInteger)getIndexWithTime:(NSTimeInterval)time
{
    NSInteger index = 0;
    for (int i = 0; i < self.count; i++)
    {
        LyricMedel *lyric = self.allLyricModelArray[i];
        if (lyric.time > time) {
            index = (i - 1 > 0) ? i - 1 : 0;
            break;
        }
    }
    return index;
}

@end
