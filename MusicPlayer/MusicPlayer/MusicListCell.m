//
//  MusicListCell.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/15.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicListCell.h"
#import "UIImageView+WebCache.h"

@implementation MusicListCell

// 重写setter方法, 给视图控件赋值
- (void)setMusic:(MusicModel *)music
{
    self.songNameLabel.text = music.name;
    self.songNameLabel.highlightedTextColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1];

    self.singerNameLabel.text = music.singer;
    self.singerNameLabel.highlightedTextColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1];
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:music.picUrl] placeholderImage:nil];
    [self layoutIfNeeded];
    self.songImageView.layer.cornerRadius = CGRectGetWidth(self.songImageView.frame) / 2;
    self.songImageView.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
}

@end
