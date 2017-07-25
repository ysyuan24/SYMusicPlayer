//
//  ViewController.m
//  MusicPlayerDemo
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 SY. All rights reserved.
//

#import "ViewController.h"
#import "SYMusicPlayer.h"
#import "MainView.h"

@interface ViewController ()

@property (nonatomic, strong) SYMusicPlayer *musicPlayer;
@property (nonatomic, weak) MainView *mainView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup {
    
    self.view.backgroundColor = [UIColor whiteColor];
    __weak __typeof(&*self)ws = self;

    [self.mainView setPlayLocalMusicBlcok:^{
        [ws playLocalMusci];
    }];
    
    [self.mainView setPlayNetMusicBlcok:^{
        [ws playNetMusic];
    }];
    
    [self.mainView setPlayBlcok:^{
        [ws.musicPlayer play];
    }];
    
    [self.mainView setPauseBlcok:^{
        [ws.musicPlayer pause];
    }];
 
    [self.mainView setSliderValueChangedBlcok:^(UISlider *slider){
        
        double seconds = slider.value * ws.musicPlayer.currentResource.totalTime;
        [ws.musicPlayer seekToTime:seconds];
    }];
    
    [self.musicPlayer setMusicPlayerPlayProgressBlock:^(SYMusicPlayerResource *resource){
        
        [ws.mainView configureWithResource:resource];
    }];
    
    [self.musicPlayer setMusicPlayerDidPlayToEndTimeBlock:^(SYMusicPlayerResource *resource){
        [ws playLocalMusci];
    }];
}

- (void)playLocalMusci {
        
    SYMusicPlayerResource *localResource = [SYMusicPlayerResource new];
    localResource.resourceURL = [[NSBundle mainBundle] pathForResource:@"music1"
                                                                ofType:@"mp3"];
    localResource.resourceID = @"music1";
    [self.musicPlayer playWithMusicResource:localResource
                                 completion:^(SYMusicPlayerResource * _Nonnull resource) {
        
                                     self.title = resource.resourceID;
                                     
                                 }];
}

- (void)playNetMusic {
    
    SYMusicPlayerResource *localResource = [SYMusicPlayerResource new];
    localResource.resourceURL = @"";
    localResource.resourceID = @"NetMusic";
    [self.musicPlayer playWithMusicResource:localResource
                                 completion:^(SYMusicPlayerResource * _Nonnull resource) {
                                     
                                     self.title = resource.resourceID;
                                 }];
}

- (SYMusicPlayer *)musicPlayer {
    return [SYMusicPlayer shareMusicPlayer];
}

- (MainView *)mainView {
    if (!_mainView) {
        MainView *view = [[MainView alloc] initWithFrame:self.view.bounds];
        _mainView = view;
        [self.view addSubview:view];
    }
    return _mainView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
