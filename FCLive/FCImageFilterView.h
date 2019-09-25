//
//  FCImageFilterView.h
//  FCLive
//
//  Created by Zhijia Zhong on 2019/9/24.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCImageFilterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

NS_ASSUME_NONNULL_END
