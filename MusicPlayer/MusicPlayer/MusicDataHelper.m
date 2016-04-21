//
//  MusicDataHelper.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/16.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicDataHelper.h"
#import "MusicModel.h"
#import <UIKit/UIKit.h>

@interface MusicDataHelper ()

@property (nonatomic, strong) NSMutableArray * allMusicModelsArray;  // 存放所有music对象

@end

@implementation MusicDataHelper

#pragma mark---获取单例对象
+ (instancetype)shareMusicDataHelper
{
    static MusicDataHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MusicDataHelper alloc] init];
    });
    return helper;
}

#pragma mark---请求数据, 并封装成model对象
- (void)requestAllMusicModelsWithUrlString:(NSString *)urlString didFinished:(BLOCK)result
{
    // 网络请求, 封装model对象
    // 防止循环引用
    __weak MusicDataHelper * dataHelperSelf = self;
    // 1、网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 同步请求数据
        NSURL * url = [NSURL URLWithString:urlString];
        NSArray * array = [NSArray arrayWithContentsOfURL:url];
        
        dataHelperSelf.allMusicModelsArray = [NSMutableArray array];
        
        // 遍历数组, 将有效信息封装成Model对象
        for (NSDictionary * dict in array)
        {
            // 使用KVC赋值
            MusicModel *model = [[MusicModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [dataHelperSelf.allMusicModelsArray addObject:model];
        }
        
        //刷新表示图由主线程来做
        dispatch_async(dispatch_get_main_queue(), ^{
            // block调用
            result();
        });
        
    });
}

#pragma make---获取model对象的个数
- (NSInteger)countOfMusicModels
{
    return [self.allMusicModelsArray count];
}


#pragma make---根据indexPath获取数组中的某个model的对象
- (MusicModel *)getMusicModelWithIndexPath:(NSIndexPath *)indexPath
{
    return self.allMusicModelsArray[indexPath.row];
}

@end
