//
//  ViewController.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/8/30.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "ViewController.h"
#import "FCRecordViewController.h"
#import "FCGPURecordViewController.h"
#import "FCPlayerViewController.h"
#import "FCPhotoViewController.h"
#import "FCImageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didClickRecordButton:(UIButton *)sender {
    if (sender.tag == 0) {
        FCRecordViewController *vc = [[FCRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 1) {
        FCGPURecordViewController *vc = [[FCGPURecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 2) {
        FCPlayerViewController *vc = [[FCPlayerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 3) {
        FCPhotoViewController *vc = [[FCPhotoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 4) {
        FCImageViewController *vc = [[FCImageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
