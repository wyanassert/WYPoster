//
//  WYPosterLayerConfig.m
//  XQPhotoDesigner
//
//  Created by wyan assert on 2017/8/8.
//  Copyright © 2017年 余小擎. All rights reserved.
//

#import "WYPosterLayerConfig.h"

@implementation WYPosterLayerConfig


#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    WYPosterLayerConfig *config = [WYPosterLayerConfig new];
    config.displayColors = [self.displayColors copy];
    
    config.gradientColors = [self.gradientColors copy];
    config.gradientPercentage = self.gradientPercentage;
    config.gradientRotateAngel = self.gradientRotateAngel;
    config.gradientEnabled = self.gradientEnabled;
    
    config.shadowEnabled = self.shadowEnabled;
    config.shadowOpacity = self.shadowOpacity;
    config.shadowBlurRadius = self.shadowBlurRadius;
    config.shadowColor = [self.shadowColor copy];
    config.shadowOffset = self.shadowOffset;
    
    return config;
}

@end
