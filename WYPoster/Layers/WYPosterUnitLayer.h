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

- (instancetype)initWithConfigUnit:(WYPosterConfigUnit *)configUnit;

@end
