//
//  WYPosterUnitLayer.h
//  WYPoster
//
//  Created by wyan assert on 2017/8/2.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class WYPosterConfigUnit;

@interface WYPosterUnitLayer : CALayer

@property (nonatomic, assign) NSUInteger row;

- (instancetype)initWithConfigUnit:(WYPosterConfigUnit *)configUnit;

- (void)setColors:(NSArray<UIColor *> *)colors;

- (void)setShadowOpacity:(CGFloat)opacity blurRadius:(CGFloat)blurRadius color:(UIColor *)color offset:(CGSize)offset;

@end
