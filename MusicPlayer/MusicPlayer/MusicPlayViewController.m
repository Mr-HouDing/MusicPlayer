//
//  MusicPlayViewController.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/16.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MusicDataHelper.h"
#import "MusicModel.h"
#import "MusicPlayHelper.h"
#import "UIImageView+WebCache.h"
#import "MusicLyricHelper.h"

#define kMusicDataHelper [MusicDataHelper shareMusicDataHelper]

#define kMusicPlayHelper [MusicPlayHelper sharedMusicPlayHelper]

#define KMusicLyricHelper [MusicLyricHelper sharedMusicLyricHelper]

@interface MusicPlayViewController ()<MusicPlayHelperDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)didClickPreviousButton:(UIButton *)sender;

- (IBAction)didClickPlayOrPause:(UIButton *)sender;

- (IBAction)didClickNextButton:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIImageView *songImageView;

@property (strong, nonatomic) IBOutlet UITableView *lyricTableView;

@property (strong, nonatomic) IBOutlet UISlider *timeSlider;

- (IBAction)didClickTimeSlider:(UISlider *)sender;

@property (strong, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *remainingTimeLabel;

@property (strong, nonatomic) IBOutlet UISlider *VolumeSlider;

- (IBAction)didClickVolumeSlider:(UISlider *)sender;

@property (nonatomic, assign) NSInteger currentIndex;   // 临时存储上一个(旧的)音乐下标

@end

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageView"]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lyricTableView.backgroundColor = [UIColor lightTextColor];
    kMusicPlayHelper.delegate = self;
    
    // 设置tableView代理
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    
    // 将songImageView设置圆角
    // 表示绘制圆之前, 提前执行布局(当使用storyboard 或 xib 使用)
    [self.view layoutIfNeeded];
    self.songImageView.layer.cornerRadius = CGRectGetWidth(self.songImageView.frame) / 2;
    self.songImageView.layer.masksToBounds = YES;
    
    self.currentIndex = -1;
    
}

#pragma mark --- 获取播放页面的视图控制器的单例对象
+ (instancetype)sharedMusicPlayVC
{
    static MusicPlayViewController *playVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 获取工程中的main.storyboard
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        playVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"playVC"];
    });
    return playVC;
}

#pragma mark --- 视图将要出现的时候,让其播放音乐
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [kMusicPlayHelper pause];
    if(self.index == self.currentIndex)
    {
        [self playOrPause];
        return;
    }
    [self playOrPause];
    [self prepareForPlaying];
}

- (void)prepareForPlaying
{
    self.currentIndex = self.index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    // 根据indexPath获取要播放哪一首歌曲对象
    MusicModel *currentMusic = [kMusicDataHelper getMusicModelWithIndexPath:indexPath];
    self.navigationItem.title = currentMusic.name;
    
    // 设置timeSlider的最大值
    self.timeSlider.maximumValue = [currentMusic.duration floatValue]/ 1000;
    
    // 设置currentTimeLabel 和 remainingTimeLabel的起始值
    self.remainingTimeLabel.text = [self setFormateWithTime:[currentMusic.duration floatValue] / 1000];
    self.currentTimeLabel.text = [self setFormateWithTime:0];
    
#pragma mark --- 设施songImageView图片
    [self.songImageView sd_setImageWithURL:[NSURL URLWithString:currentMusic.picUrl] placeholderImage:[UIImage imageNamed:@"music"]];
    
    
#pragma mark --- 准备播放
    [kMusicPlayHelper preparePlayingMusicWithUrlString:currentMusic.mp3Url];
    
#pragma mark --- 开始准备歌词
    [KMusicLyricHelper parseLyricWithLyricString:currentMusic.lyric];
    // 刷新歌词表示图
    [self.lyricTableView reloadData];
    
    
}

- (NSString *)setFormateWithTime:(NSTimeInterval)time
{
    // 分钟
    int minute = time / 60;
    // 秒
    int seconds = (int) time % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minute, seconds];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --- 通过播放状态判断播放按钮
- (void)playOrPause
{
    if ([kMusicPlayHelper isPlaying] == YES)
    {
        [self.playButton setImage:[UIImage imageNamed:@"iconfont-bofangqibofang"] forState:(UIControlStateNormal)];
//         setTitle:@"播放" forState:(UIControlStateNormal)];
        [kMusicPlayHelper pause];
    }
    else
    {
        [self.playButton setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:(UIControlStateNormal)];
//         setTitle:@"暂停" forState:(UIControlStateNormal)];
        [kMusicPlayHelper play];
    }
}

- (IBAction)didClickPreviousButton:(UIButton *)sender {
    
    self.timeSlider.value = 0;
    
    [kMusicPlayHelper pause];
    
    self.index--;
    if (self.index == -1)
    {
        self.index = 0;
    }
    
    
    [self playOrPause];
    
    [self prepareForPlaying];
    
    [kMusicPlayHelper play];
}

- (IBAction)didClickPlayOrPause:(UIButton *)sender {
    
    [self playOrPause];
    
}

- (IBAction)didClickNextButton:(UIButton *)sender {
    
    self.timeSlider.value = 0;
    
    [kMusicPlayHelper pause];
    
    self.index++;
    if (self.index == [kMusicDataHelper countOfMusicModels])
    {
        self.index = 0;
    }
    
    [self playOrPause];
    
    [self prepareForPlaying];
    
    [kMusicPlayHelper play];
}
- (IBAction)didClickTimeSlider:(UISlider *)sender {
    
//    NSLog(@"时间: %f",self.timeSlider.value);
    [kMusicPlayHelper seekToPlayWithTime:self.timeSlider.value];
    
    
    
}
- (IBAction)didClickVolumeSlider:(UISlider *)sender {
    
    kMusicPlayHelper.volume = sender.value;
    
}

#pragma mark -- 实现MusicPlayHelperDelegate协议中的代理方法
- (void)playingToTime:(NSTimeInterval)time
{
    // 让songImageView旋转
    // 弧度 = 角度 * π / 180
    self.songImageView.transform = CGAffineTransformRotate(self.songImageView.transform, M_2_PI / 180);
    
    // 跟上走
    self.timeSlider.value = time;
    
    // 设置timeSlider的最大值
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    // 根据indexPath获取要播放哪一首歌曲对象
    MusicModel *currentMusic = [kMusicDataHelper getMusicModelWithIndexPath:indexPath];
    
    // 设置currentTimeLabel 和 remainingTimeLabel的起始值
    self.remainingTimeLabel.text = [self setFormateWithTime:[currentMusic.duration floatValue] / 1000 - time];
    self.currentTimeLabel.text = [self setFormateWithTime:time];
    
    // 根据下标显示哪一行的歌词
    NSInteger index = [KMusicLyricHelper getIndexWithTime:time];
    // 选中哪一行
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:index inSection:0];
    [self.lyricTableView selectRowAtIndexPath:indexPath1 animated:NO scrollPosition:(UITableViewScrollPositionMiddle)];
}


- (void)playingDidEnd
{
    [kMusicPlayHelper pause];
    self.index++;
    if (self.index == [kMusicDataHelper countOfMusicModels])
    {
        self.index = 0;
    }
    [self prepareForPlaying];
    [kMusicPlayHelper play];
}

#pragma mark -- 实现tableView协议中的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return KMusicLyricHelper.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lyricCell" forIndexPath:indexPath];
    cell.textLabel.text = [KMusicLyricHelper lyricWithIndexPath:indexPath].lyricString;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    return cell;
}

- (void)dealloc
{
    kMusicPlayHelper.delegate = nil;
}

@end
