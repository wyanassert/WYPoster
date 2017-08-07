//
//  WYPoster.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WYPosterLayer.h"

@class WYPosterConfigModel;

@interface WYPoster : NSObject

+ (WYPosterConfigModel *)fillLayoutData:(NSString *)text withConfig:(WYPosterConfigModel *)configModel;

+ (WYPosterLayer *)createLayerUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel;

+ (NSArray<WYPosterConfigModel *> *)getAllConfigModels;

@end
