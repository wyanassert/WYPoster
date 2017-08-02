//
//  WYPoster.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WYPosterView.h"
#import "WYPosterLayer.h"

@class WYPosterConfigModel;

@interface WYPoster : NSObject

+ (WYPosterConfigModel *)fillLayoutData:(NSString *)text withConfig:(WYPosterConfigModel *)configModel;

+ (WYPosterView *)createViewUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel;

+ (WYPosterLayer *)createLayerUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel;

@end
