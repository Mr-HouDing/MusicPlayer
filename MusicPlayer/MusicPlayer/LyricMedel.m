//
//  LyricMedel.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/20.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "LyricMedel.h"

@implementation LyricMedel

// 自定义初始化方法
- (instancetype)initWithTime:(NSTimeInterval)time lyricString:(NSString *)lyricString
{
    self = [super init];
    if (self)
    {
        self.lyricString = lyricString;
        self.time = time;
    }
    return self;
}

@end
