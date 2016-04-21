//
//  MusicDataHelper.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/16.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void(^BLOCK)();

@interface MusicDataHelper : NSObject

#pragma mark---获取单例对象
+ (instancetype)shareMusicDataHelper;

#pragma mark---请求数据, 并封装成model对象
- (void)requestAllMusicModelsWithUrlString:(NSString *)urlString didFinished:(BLOCK)result;

#pragma make---获取model对象的个数
- (NSInteger)countOfMusicModels;

#pragma make---根据indexPath获取数组中的某个model的对象
- (MusicModel *)getMusicModelWithIndexPath:(NSIndexPath *)indexPath;

@end
