//
//  SYMusicPlayer.m
//  MusicPlayerDemo
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 SY. All rights reserved.
//

#import "SYMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>

static NSString *const PlayerStatusKeyPath      = @"playerStatus";
static NSString *const PlayerItemStatusKeyPath  = @"status";


@interface SYMusicPlayer()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic ,strong)  id timeObser;
@property (nonatomic, assign, readwrite) SYMusicPlayerStatus playerStatus;
@property (nonatomic, strong, readwrite) SYMusicPlayerResource *currentResource;
@property (nonatomic, copy) void(^playWithMusicResourceCompletion)(SYMusicPlayerResource *resource);

@end

@implementation SYMusicPlayer

#pragma mark - share
+ (instancetype) shareMusicPlayer {
    
    static SYMusicPlayer *musicPlayer = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        musicPlayer = [[SYMusicPlayer alloc] init];
    });
    return musicPlayer;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.playerStatus = SYMusicPlayerStatusStop;
        [self addPlayerStatusObserver];
    }
    return self;
}

#pragma mark - Observer
- (void)addPlayerStatusObserver {

    [self addObserver:self
           forKeyPath:PlayerStatusKeyPath
              options:NSKeyValueObservingOptionNew context:nil];
}


#pragma makr - operation
//play resource
- (void)playWithMusicResource:(SYMusicPlayerResource *)resource
                   completion:(void(^)(SYMusicPlayerResource *resource))completion {
    
    if (!resource.resourceURL.length) {
        
        if (completion) {
            [resource setValue:@(SYMusicPlayerLoadStatusStatusFailed)
                        forKey:NSStringFromSelector(@selector(loadStatus))];
            
            completion(resource);
        }
        return;
    }
    
    
    if (self.player.currentItem) {
        [self stop];
    }
    
    self.playWithMusicResourceCompletion = completion;
    [self replaceCurrentItemWithPlayerItem:[self getPlayerItemWithResource:resource]];
    self.currentResource = resource;
}

#pragma mark -
- (AVPlayerItem *)getPlayerItemWithResource:(SYMusicPlayerResource *)resource {
    
    NSURL *url = nil;
    if ([resource.resourceURL hasPrefix:@"http"]) {
        
        url = [NSURL URLWithString:resource.resourceURL];
        [resource setValue:@(SYMusicPlayerResourceTypeNet)
                    forKey:NSStringFromSelector(@selector(resourceType))];
    }else{
        url = [NSURL fileURLWithPath:resource.resourceURL];
        [resource setValue:@(SYMusicPlayerResourceTypeLocal)
                    forKey:NSStringFromSelector(@selector(resourceType))];
    }
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    return item;
}

#pragma mark - replaceCurrentItem
- (void)replaceCurrentItemWithPlayerItem:(AVPlayerItem *)playerItem {
    
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    //kvo
    [self.player.currentItem addObserver:self
                              forKeyPath:PlayerItemStatusKeyPath
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayFinished)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
    
}

#pragma makr - observe
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:PlayerStatusKeyPath]) {
        
        //playerStatus
        if (self.MusicPlayerStatusChangedBlock) {
            self.MusicPlayerStatusChangedBlock(self.playerStatus);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SYMusicerPlayStatusChanged
                                                            object:nil userInfo:nil];
        
    } else if ([keyPath isEqualToString:PlayerItemStatusKeyPath]) {
        
        //playerItemStatus
        AVPlayerItem *item = object;
        
        switch ([item status]) {
            case AVPlayerStatusUnknown:
                
                [self stop];
                [self.currentResource setValue:@(SYMusicPlayerLoadStatusUnknown)
                                        forKey:@"loadStatus"];

                break;
                
            case AVPlayerStatusReadyToPlay:
                
                [self play];
                [self.currentResource setValue:@(SYMusicPlayerLoadStatusReadyToPlay)
                                        forKey:@"loadStatus"];

                //duration
                CGFloat duration = CMTimeGetSeconds(item.duration);
                if (duration > CGFLOAT_MIN && duration < CGFLOAT_MAX) {
                    [self.currentResource setValue:@(duration) forKey:@"totalTime"];
                }
                
                //Timer
                [self addPeriodicTimeObserver];

                break;
                
            case AVPlayerStatusFailed:
                
                [self stop];
                [self.currentResource setValue:@(SYMusicPlayerLoadStatusStatusFailed)
                                        forKey:@"loadStatus"];
            
                break;
        }
        
        [self.player.currentItem removeObserver:self
                                     forKeyPath:PlayerItemStatusKeyPath context:nil];
        
        if (self.playWithMusicResourceCompletion) {
            self.playWithMusicResourceCompletion(self.currentResource);
        }
    }
}

#pragma mark - timer
- (void)addPeriodicTimeObserver {
    
    
    __block SYMusicPlayerResource *resource = self.currentResource;
    __weak __typeof(&*self)ws = self;
    
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                                               queue:dispatch_get_main_queue()
                                                          usingBlock:^(CMTime time){
                                             
        CGFloat currentTime = CMTimeGetSeconds(time);
        [resource setValue:@(currentTime)
                    forKey:@"currentTime"];
                                             
        if (ws.MusicPlayerPlayProgressBlock) {
            ws.MusicPlayerPlayProgressBlock(resource);
        }
    }];
}

#pragma mark -
- (void)musicPlayFinished {
    
    [self stop];
    if (self.MusicPlayerDidPlayToEndTimeBlock) {
        self.MusicPlayerDidPlayToEndTimeBlock(self.currentResource);
    }
}

//play
- (void)play {
    
    [self.player play];
    self.playerStatus = SYMusicPlayerStatusPlay;
}

//pause
- (void)pause {
    
    [self.player pause];
    self.playerStatus = SYMusicPlayerStatusPause;
}

//stop
- (void)stop {
 
    self.playerStatus = SYMusicPlayerStatusStop;
}

//seekToTime
- (void)seekToTime:(double)time {
    
    if (self.playerStatus == SYMusicPlayerStatusStop) return;
    
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale)
          completionHandler:^(BOOL finished) {
                   [self play];
               }];
}

#pragma makr - player
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

#pragma mark - release
- (void)dealloc {
    
    [self stop];
    [self removeObserver:self forKeyPath:PlayerStatusKeyPath];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                              forKeyPath:AVPlayerItemDidPlayToEndTimeNotification];
}

@end

@implementation SYMusicPlayerResource

@end
