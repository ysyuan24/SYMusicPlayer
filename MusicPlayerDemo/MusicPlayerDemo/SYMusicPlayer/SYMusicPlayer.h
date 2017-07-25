//
//  SYMusicPlayer.h
//  MusicPlayerDemo
//
//  Created by SY on 2017/7/21.
//  Copyright © 2017年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYMusicPlayerResource;

NS_ASSUME_NONNULL_BEGIN
//StatusChanged Notification
static NSString *const SYMusicerPlayStatusChanged = @"SYMusicerPlayStatusChanged";

//PlayerStatus
typedef NS_OPTIONS(NSUInteger, SYMusicPlayerStatus) {
    SYMusicPlayerStatusStop     = 1 << 0,
    SYMusicPlayerStatusPause    = 1 << 1,
    SYMusicPlayerStatusPlay     = 1 << 2,
};

//PlayerLoadStatus
typedef NS_OPTIONS(NSUInteger, SYMusicPlayerLoadStatus) {
    SYMusicPlayerLoadStatusUnknown      = 1 << 0,
    SYMusicPlayerLoadStatusReadyToPlay  = 1 << 1,
    SYMusicPlayerLoadStatusStatusFailed = 1 << 2,
};

//ResourceType
typedef NS_OPTIONS(NSUInteger, SYMusicPlayerResourceType) {
    SYMusicPlayerResourceTypeLocal  = 1 << 0,
    SYMusicPlayerResourceTypeNet    = 1 << 1
};

@interface SYMusicPlayer : NSObject

+ (instancetype) shareMusicPlayer;

#pragma makr - Status
//current playerStatus
@property (nonatomic, assign, readonly) SYMusicPlayerStatus playerStatus;
//current resourece
@property (nonatomic, strong, readonly) SYMusicPlayerResource *currentResource;

#pragma makr - Block
//MusicPlayerStatusChanged
@property (nonatomic, copy) void(^MusicPlayerStatusChangedBlock)(SYMusicPlayerStatus playerStatus);

//MusicPlayerPlayProgress
@property (nonatomic, copy) void(^MusicPlayerPlayProgressBlock)(SYMusicPlayerResource *resource);

//MusicPlayerDidPlayToEndTime
@property (nonatomic, copy) void(^MusicPlayerDidPlayToEndTimeBlock)(SYMusicPlayerResource *resource);

#pragma makr - operation
//play resource
- (void)playWithMusicResource:(SYMusicPlayerResource *)resource
                   completion:(void(^)(SYMusicPlayerResource *resource))completion;

//play
- (void)play;
//pause
- (void)pause;
//stop
- (void)stop;
//seekToTime
- (void)seekToTime:(double)time;

@end

@interface SYMusicPlayerResource : NSObject

#pragma mark - Must
//Local Or Net
@property (nonatomic, copy) NSString *resourceURL;
@property (nonatomic, copy) NSString *resourceID;

#pragma mark - Status
@property (nonatomic, assign, readonly) SYMusicPlayerResourceType resourceType;
@property (nonatomic, assign, readonly) SYMusicPlayerLoadStatus loadStatus;
@property (nonatomic, assign, readonly) double totalTime;
@property (nonatomic, assign, readonly) double currentTime;

@end
NS_ASSUME_NONNULL_END

