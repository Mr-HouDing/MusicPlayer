//
//  MusicListTableViewController.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/15.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "Urls.h"
#import "MusicModel.h"
#import "MusicListCell.h"
#import "MusicDataHelper.h"
#import "MusicPlayViewController.h"

#define kMusicDataHelper [MusicDataHelper shareMusicDataHelper]

@interface MusicListTableViewController ()

- (IBAction)didClickPlayingBarButton:(UIBarButtonItem *)sender;

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
    imageView.frame = [[self view] bounds];
    self.tableView.backgroundView = imageView;
    
    __weak MusicListTableViewController *listVC = self;
    
    // 网络请求
    [kMusicDataHelper requestAllMusicModelsWithUrlString:kMusicListUrl didFinished:^{
        [listVC.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 实现协议中的方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [kMusicDataHelper countOfMusicModels];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell" forIndexPath:indexPath];
    
    
    // 根据indexPath获取musicModel对象
    MusicModel *music = [kMusicDataHelper getMusicModelWithIndexPath:indexPath];
    
    cell.music = music;
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayViewController *playVC = [MusicPlayViewController sharedMusicPlayVC];
    playVC.index = indexPath.row;
    
    [self.navigationController showViewController:playVC sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickPlayingBarButton:(UIBarButtonItem *)sender {
    
    MusicPlayViewController *playVC = [MusicPlayViewController sharedMusicPlayVC];
    [self.navigationController showViewController:playVC sender:self];
    
}
@end
