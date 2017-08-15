//
//  CLViewController.m
//  avFoundation_audio
//
//  Created by tidemedia on 2017/8/15.
//  Copyright © 2017年 charly. All rights reserved.
//

#import "CLViewController.h"
#import "CLAvAudioPlayerUtils.h"

@interface CLViewController ()

@property (strong, nonatomic) CLAvAudioPlayerUtils *audioPlayerUtils;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@end

@implementation CLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _audioPlayerUtils = [CLAvAudioPlayerUtils avAudioPlayerShareInstance];
    [_audioPlayerUtils addPlayerWithPathName:@"guitar"];
    [_audioPlayerUtils addPlayerWithPathName:@"bass"];
    [_audioPlayerUtils addPlayerWithPathName:@"drums"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)adjustRate:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustRate:slider.value];
}

- (IBAction)adjustGuitarVolume:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustVolume:slider.value index:0];
}

- (IBAction)adjustGuitarPan:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustPan:slider.value index:0];
}

- (IBAction)adjustBassVolume:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustVolume:slider.value index:1];
}

- (IBAction)adjustBassPan:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustPan:slider.value index:1];
}

- (IBAction)adjustDrumsVolume:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustVolume:slider.value index:2];
}

- (IBAction)adjustDrumsPan:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [_audioPlayerUtils adjustPan:slider.value index:2];
}


- (IBAction)playAction:(id)sender {
    if (_audioPlayerUtils.isPlaying) {
        [_audioPlayerUtils pause];
        [_playBtn setSelected:NO];
    } else {
        [_audioPlayerUtils paly];
        [_playBtn setSelected:YES];
    }
    [_stopBtn setEnabled:YES];
}

- (IBAction)stopAction:(id)sender {
    [_audioPlayerUtils stop];
    [_playBtn setSelected:NO];
    [_stopBtn setEnabled:NO];
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
