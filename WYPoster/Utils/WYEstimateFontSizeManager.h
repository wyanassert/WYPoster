//
//  WYEstimateFontSizeManager.h
//  WYPoster
//
//  Created by wyan assert on 2017/8/7.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WYPosterFont.h"

@interface WYEstimateFontSizeManager : NSObject

+ (instancetype)shareedInstance;

- (CGSize)estimateWYPosterFont:(WYPosterFont *)font;

@end
