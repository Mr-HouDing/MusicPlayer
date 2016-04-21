//
//  MusicListCell.h
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/15.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface MusicListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *singerNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

// 用来接受传过来的music对象
@property (nonatomic, strong) MusicModel *music;

@end
