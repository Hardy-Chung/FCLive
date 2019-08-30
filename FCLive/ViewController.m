//
//  ViewController.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/8/30.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "ViewController.h"
#import "FCRecordViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didClickRecordButton:(UIButton *)sender {
    FCRecordViewController *vc = [[FCRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
