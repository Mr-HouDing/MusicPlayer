//
//  MusicModel.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/15.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, copy) NSString * mp3Url;  // 歌曲网址
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * name;  // 歌曲名
@property (nonatomic, copy) NSString * picUrl;  // 图片网址
@property (nonatomic, copy) NSString * blurPicUrl;
@property (nonatomic, copy) NSString * album;
@property (nonatomic, copy) NSString * singer;  // 歌手名
@property (nonatomic, copy) NSString * duration;  // 歌曲时长
@property (nonatomic, copy) NSString * artists_name;
@property (nonatomic, copy) NSString * lyric;  // 歌词

@end
