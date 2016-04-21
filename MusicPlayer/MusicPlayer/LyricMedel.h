//
//  LyricMedel.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/20.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricMedel : NSObject

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, copy) NSString *lyricString;

// 自定义初始化方法
- (instancetype)initWithTime:(NSTimeInterval)time lyricString:(NSString *)lyricString;

@end
