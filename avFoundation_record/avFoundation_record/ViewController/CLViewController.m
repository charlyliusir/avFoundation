//
//  CLViewController.m
//  avFoundation_record
//
//  Created by tidemedia on 2017/8/16.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLViewController.h"
#import "CLaVRecordUtils.h"
#import "CLaVAudioPlayerUtils.h"
#import "CLMemoItem.h"
#import "CLLevelPair.h"

/// 录音实例
/// 1、我们可以录制一个音频, 保存到本地列表, 制作成一个音频备忘录
/// 2、录制成功保存到本地, 本地文件可以通过 AudioPlayer 播放
/// 3、录制过程不允许播放音频
/// 4、播放音频的过程中, 开始录制则停止播放
/// 5、录制过程中随时更新录制时间, 音量大小

#define kAVRecordTableViewCellIndentifier @"AVRecordTableViewCellIndentifier"
#define kAVRecordTableViewCellRowHeight   44

#define kArchivePath @"memo.archive"

@interface CLViewController () <UITableViewDelegate, UITableViewDataSource, CLaVRecordUtilsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *volumeProgress;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (strong, nonatomic) CLaVRecordUtils *recordUtils;
@property (strong, nonatomic) CLaVAudioPlayerUtils *playerUtils;

@property (strong, nonatomic) NSTimer *timeTimer; /// 更新录制时间
@property (strong, nonatomic) NSTimer *volumeTimer; /// 更新音量

@property (strong, nonatomic) NSMutableArray <CLMemoItem *>*memoLists;

@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _recordUtils = [[CLaVRecordUtils alloc] init];
    _playerUtils = [[CLaVAudioPlayerUtils alloc] init];
    
    NSData *memoData = [NSData dataWithContentsOfURL:[self archiverURL]];
    if (!memoData) {
        _memoLists = [NSMutableArray array];
    } else {
        _memoLists = [NSKeyedUnarchiver unarchiveObjectWithData:memoData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (IBAction)startRecordAction:(id)sender {
    
    if (_playerUtils.isPlaying) {
        [_playerUtils stop];
    }
    if (_recordUtils.isRecording) {
        [_recordUtils stopWithCompletionHandler:^(BOOL result) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"录制完成"
                                                  message:@"请给你的作品命名"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setPlaceholder:@"作品名称"];
            }];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *fileName = alertController.textFields.firstObject.text;
                [_recordUtils saveRecordingWithName:fileName completionHandle:^(BOOL success, id memo) {
                    if (success) {
                        [_memoLists addObject:(CLMemoItem *)memo];
                        [self saveMemo];
                        [_tableView reloadData];
                    } else {
                        NSLog(@"Save Recording Error : %@", ((NSError *)memo).localizedDescription);
                    }
                }];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        [self stopTime];
        [self stopVolume];
        _timeLabel.text = @"00:00:00";
    } else {
        [_recordUtils record];
        [self startTime];
        [self startVolume];
    }
    
    [_playBtn setSelected:_recordUtils.isRecording];
}

- (void)saveMemo
{
    NSData *memoData = [NSKeyedArchiver archivedDataWithRootObject:_memoLists];
    [memoData writeToURL:[self archiverURL] atomically:YES];
}

- (NSURL *)archiverURL
{
    NSString *doucmentPath = [NSString doucmentPath];
    NSString *archiverPath = [doucmentPath stringByAppendingPathComponent:kArchivePath];
    return [NSURL fileURLWithPath:archiverPath];
}

- (void)startTime {
    [_timeTimer invalidate];
    _timeTimer = [NSTimer timerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _timeLabel.text = _recordUtils.formatCurrentTime;
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timeTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTime {
    [_timeTimer invalidate];
    [self setTimeTimer:nil];
}

- (void)startVolume {
    [_volumeTimer invalidate];
    _volumeTimer = [NSTimer timerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _volumeProgress.progress = [_recordUtils levels].level;
    }];
    [[NSRunLoop currentRunLoop] addTimer:_volumeTimer forMode:NSRunLoopCommonModes];
}

- (void)stopVolume {
    [_volumeTimer invalidate];
    [self setVolumeTimer:nil];
}

#pragma mark - CLaVRecordUtilsDelegate
- (void)interruptionBegin
{
    [_playBtn setSelected:NO];
    [self stopTime];
    [self stopVolume];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_recordUtils.isRecording) {
        [_playerUtils playVoiceWithUrl:_memoLists[indexPath.row].url];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAVRecordTableViewCellRowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _memoLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAVRecordTableViewCellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kAVRecordTableViewCellIndentifier];
    }
    CLMemoItem *memo = _memoLists[indexPath.row];
    cell.textLabel.text = memo.title;
    cell.detailTextLabel.text = [memo.date stringByAppendingString:memo.time];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
