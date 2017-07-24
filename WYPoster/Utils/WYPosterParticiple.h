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

+ (WYPosterConfigModel *)spliteWordArray:(NSArray<NSString *> *)wordArray lengthPerLine:(NSUInteger)avg withConfig:(WYPosterConfigModel *)configModel;

@end
