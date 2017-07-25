//
//  MainView.h
//  MusicPlayerDemo
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView

@property (nonatomic, copy) void(^playBlcok)();
@property (nonatomic, copy) void(^pauseBlcok)();
@property (nonatomic, copy) void(^sliderValueChangedBlcok)(UISlider *slider);
@property (nonatomic, copy) void(^playLocalMusicBlcok)();
@property (nonatomic, copy) void(^playNetMusicBlcok)();

- (void)configureWithResource:(id)resource;

@end
