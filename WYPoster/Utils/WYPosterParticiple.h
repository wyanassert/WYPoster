//
//  WYPosterParticiple.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYPosterConfigModel;

@interface WYPosterParticiple : NSObject

+ (NSArray<NSString *> *)getWordFromString:(NSString *)text withConfig:(WYPosterConfigModel *)configModel;

+ (WYPosterConfigModel *)calAvgLengthForConfigModel:(WYPosterConfigModel *)configModel withText:(NSString *)text;

+ (WYPosterConfigModel *)spliteWordArray:(NSArray<NSString *> *)wordArray withConfig:(WYPosterConfigModel *)configModel;

@end
