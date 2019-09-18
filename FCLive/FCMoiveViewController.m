//
//  FCMoiveViewController.m
//  FCLive
//
//  Created by Sergeant on 2019/9/18.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCMoiveViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <GPUImage/GPUImage.h>

@interface FCMoiveViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, GPUImageMovieWriterDelegate>

@end

@implementation FCMoiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Album" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem:)];
}

- (void)didClickRightItem:(UIBarButtonItem *)item {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.mediaTypes = @[(NSString *) kUTTypeMovie];
    vc.allowsEditing = NO;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSURL *movieURL = info[UIImagePickerControllerMediaURL];
    
    GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithURL:movieURL];
    GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
    
    [movieFile addTarget:pixellateFilter];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *resultURL = [NSURL fileURLWithPath:pathToMovie];
    
    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:resultURL size:CGSizeMake(480.0, 640.0)];
    [pixellateFilter addTarget:movieWriter];
    
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

- (void)movieRecordingCompleted {
    
}

- (void)movieRecordingFailedWithError:(NSError*)error {
    
}

@end
