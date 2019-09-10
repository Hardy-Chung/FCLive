//
//  FCPlayerViewController.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/9/10.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCPlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface FCPlayerViewController ()

@property (nonatomic, strong) IJKFFMoviePlayerController *player;

@end

@implementation FCPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 拉流地址
    NSString *str = @"http:113.215.16.65/wssource.pull.inke.cn/live/1568092307157860_0.flv?ikDnsOp=1001&ikHost=ws&ikOp=0&codecInfo=8192&ikLog=1&ikSyncBeta=1&ikChorus=1&dpSrc=40&push_host=push.cls.inke.cn&msUid=731047872&msSmid=D20lkVNFrPFiS9WT8kWlidFBs2znUUEPwpUG7BadHTvZ4Xbe&ikMinBuf=2900&ikMaxBuf=3600&ikSlowRate=0.9&ikFastRate=1.1&wsiphost=ipdb";
    NSURL *url = [NSURL URLWithString:str];
    
    // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    // 准备播放
    [_player prepareToPlay];
    
    _player.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:_player.view atIndex:0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_player pause];
    [_player stop];
    _player = nil;
}

@end
