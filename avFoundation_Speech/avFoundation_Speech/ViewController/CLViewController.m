//
//  CLViewController.m
//  avFoundation_Speech
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLViewController.h"
#import "CLAvSpeechUtils.h"

#define DefaultCellHeight 44
#define kAvSpeechCellIdentifier @"avSpeechCellIdentifier"

@interface CLViewController () <UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/// 预置朗读数据
@property (copy, nonatomic) NSArray *avSpeechResources;
/// 当前选中资源索引
@property (assign, nonatomic) NSUInteger sourceIndex;
/// 当前朗读内容
@property (copy, nonatomic) NSString *sourceString;

@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CLAvSpeechUtils avSpeechUtilSharedInstance].speechSynthsizer.delegate = self;
    
    _avSpeechResources = @[
                           @"白日依山尽, 黄河入海流, 欲穷千里目, 更上一层楼",
                           @"窗前明月光, 疑是地上霜, 举头望明月, 低头思故乡",
                           @"小荷才露尖尖角, 早有蜻蜓立上头"
                           ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAction:(id)sender {
    AVSpeechSynthesizer *avSpeechSynthesizer = [[CLAvSpeechUtils avSpeechUtilSharedInstance] speechSynthsizer];
    
    if (avSpeechSynthesizer.isPaused) {
        /// 如果在暂停, 则继续
        [[CLAvSpeechUtils avSpeechUtilSharedInstance] continue];
    } else if (avSpeechSynthesizer.isSpeaking) {
        /// 如果在播放, 则暂停
        [[CLAvSpeechUtils avSpeechUtilSharedInstance] pause];
    }else {
        /// 如果在结束, 则开始
        [[CLAvSpeechUtils avSpeechUtilSharedInstance] playSpeechString:_sourceString];
    }
}

- (IBAction)stopAction:(id)sender {
    [[CLAvSpeechUtils avSpeechUtilSharedInstance] stop];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != _sourceIndex) {
        _sourceIndex   = indexPath.row;
        _sourceString  = _avSpeechResources[indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DefaultCellHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _avSpeechResources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAvSpeechCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAvSpeechCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.text = _avSpeechResources[indexPath.row];
    return cell;
}

#pragma mark - AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [_playBtn setSelected:YES];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [_playBtn setSelected:NO];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [_playBtn setSelected:NO];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [_playBtn setSelected:YES];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    [_playBtn setSelected:NO];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    /// 这里可以提供朗读内容清晰标注功能
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
