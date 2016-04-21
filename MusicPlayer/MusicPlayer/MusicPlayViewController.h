//
//  MusicPlayViewController.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/16.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayViewController : UIViewController

// 接收列表页面传过来的值
@property (nonatomic, assign) NSInteger index;


#pragma mark --- 获取播放页面的视图控制器的单例对象
+ (instancetype)sharedMusicPlayVC;

@end
