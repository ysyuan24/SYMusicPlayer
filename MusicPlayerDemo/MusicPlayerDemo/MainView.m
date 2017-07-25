//
//  MainView.m
//  MusicPlayerDemo
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 SY. All rights reserved.
//

#import "MainView.h"
#import "SYMusicPlayer.h"

@interface MainView ()

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *totalTime;
@property (nonatomic, strong) UISlider *playSlider;
@property (nonatomic, strong) UIButton *playLocalMusciButton;
@property (nonatomic, strong) UIButton *playNetMusciButton;

@end

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.currentTime];
        [self addSubview:self.totalTime];
        [self addSubview:self.playSlider];
        [self addSubview:self.playLocalMusciButton];
        [self addSubview:self.playNetMusciButton];
    }
    return self;
}

- (void)configureWithResource:(SYMusicPlayerResource *)resource {
    
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)resource.currentTime/60, (int)resource.currentTime%60];
    
    self.totalTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)resource.totalTime/60, (int)resource.totalTime%60];
    
    self.playSlider.value = resource.currentTime / resource.totalTime;
}

- (void)play {
    
    if (self.playBlcok) self.playBlcok();
}

- (void)pause {
    
    if (self.pauseBlcok) self.pauseBlcok();
}

- (void)sliderValueChanged:(UISlider *)slider {

    if (self.sliderValueChangedBlcok) self.sliderValueChangedBlcok(slider);
}

- (void)playLocalMusci {
    
    if (self.playLocalMusicBlcok) self.playLocalMusicBlcok();
}

- (void)playNetMusci {
    
    if (self.playNetMusicBlcok) self.playNetMusicBlcok();
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(100, 170, 40, 50);
        [_playButton setTitle:@"play" forState:UIControlStateNormal];
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(play)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.frame = CGRectMake(250, 170, 60, 50);
        [_pauseButton setTitle:@"pause" forState:UIControlStateNormal];
        [_pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(pause)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UILabel *)currentTime {
    if (!_currentTime) {
        _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(100, 250, 100, 30)];
    }
    return _currentTime;
}

- (UILabel *)totalTime {
    if (!_totalTime) {
        _totalTime = [[UILabel alloc] initWithFrame:CGRectMake(300, 250, 100, 30)];
    }
    return _totalTime;
}

- (UISlider *)playSlider {

    if (!_playSlider) {
        _playSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 300, 250, 30)];
        [_playSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _playSlider;
}

- (UIButton *)playLocalMusciButton {
    if (!_playLocalMusciButton) {
        _playLocalMusciButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playLocalMusciButton.frame = CGRectMake(100, self.bounds.size.height - 200, 200, 50);
        _playLocalMusciButton.backgroundColor = [UIColor lightGrayColor];
        [_playLocalMusciButton setTitle:@"play local music" forState:UIControlStateNormal];
        [_playLocalMusciButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playLocalMusciButton addTarget:self action:@selector(playLocalMusci)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    return _playLocalMusciButton;
}

- (UIButton *)playNetMusciButton {
    if (!_playNetMusciButton) {
        _playNetMusciButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playNetMusciButton.frame = CGRectMake(100, self.bounds.size.height - 100, 200, 50);
        _playNetMusciButton.backgroundColor = [UIColor lightGrayColor];
        [_playNetMusciButton setTitle:@"play local music" forState:UIControlStateNormal];
        [_playNetMusciButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playNetMusciButton addTarget:self action:@selector(playNetMusci)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _playNetMusciButton;
}

@end
