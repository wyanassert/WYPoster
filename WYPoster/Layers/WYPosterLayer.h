//
//  WYPosterLayer.h
//  WYPoster
//
//  Created by wyan assert on 2017/8/1.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class WYPosterConfigModel;

@interface WYPosterLayer : CALayer

- (instancetype)initWithConfigModel:(WYPosterConfigModel *)configModel;

@end
