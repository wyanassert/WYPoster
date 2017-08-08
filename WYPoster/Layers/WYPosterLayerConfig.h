//
//  WYPosterLayerConfig.h
//  XQPhotoDesigner
//
//  Created by wyan assert on 2017/8/8.
//  Copyright © 2017年 余小擎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPosterLayerConfig : NSObject <NSCopying>

@property (nonatomic, strong) NSArray<UIColor *> *displayColors;
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;
@property (nonatomic, assign) CGFloat         gradientPercentage;
@property (nonatomic, assign) CGFloat         gradientRotateAngel;
@property (nonatomic, assign) BOOL            gradientEnabled;

@end
