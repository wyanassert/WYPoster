//
//  WYPosterLayer.h
//  WYPoster
//
//  Created by wyan assert on 2017/8/1.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "WYPosterLayerConfig.h"

@class WYPosterConfigModel;
@class WYPosterConfigPart;

@interface WYPosterLayer : CALayer

- (instancetype)initWithConfigModel:(WYPosterConfigModel *)configModel;
- (instancetype)initWithConfigpart:(WYPosterConfigPart *)configPart;

- (void)setColor:(NSArray<UIColor *> *)colors;

- (void)setGradientColor:(NSArray<UIColor *> *)colors percentage:(CGFloat)percentage rotate:(CGFloat)rotate;
- (void)closeGradient;

- (void)setShadowOpacity:(CGFloat)opacity blurRadius:(CGFloat)blurRadius color:(UIColor *)color offset:(CGSize)offset;

- (void)loadLayerConfig:(WYPosterLayerConfig *)layerConfig;

@end
