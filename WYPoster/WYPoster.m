//
//  WYPoster.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPoster.h"
#import "WYPosterConfigModel.h"
#import "WYPosterView.h"
#import "WYPosterConfigPart.h"
#import "WYPosterConfigLine.h"
#import "WYPosterParticiple.h"

@implementation WYPoster

+ (WYPosterConfigModel *)fillLayoutData:(NSString *)text withConfig:(WYPosterConfigModel *)configModel {
    NSArray<NSString *> *wordArray = [WYPosterParticiple getWordFromString:text withConfig:configModel];
    [WYPosterParticiple calAvgLengthForConfigModel:configModel withText:text];
    [WYPosterParticiple spliteWordArray:wordArray withConfig:configModel];
    
    CGFloat tmpRatio = [WYPoster checkIfRatioReasonable:configModel];
    NSUInteger count = 3;
    WYPosterConfigPart *tmpPart = configModel.configPart;
//    NSLog(@"%f", [WYPoster checkIfRatioReasonable:configModel]);
    while ([WYPoster checkIfRatioReasonable:configModel] > 0.3 && count--) {
        CGFloat tmpAvg = configModel.avgLength;
        if([WYPoster checkIfRatioReasonable:configModel] > 1) {
            tmpAvg *= 0.8;
        } else {
            tmpAvg *= 1.2;
        }
        [configModel cleanConfigPart];
        configModel.avgLength = tmpAvg;
        [WYPosterParticiple spliteWordArray:wordArray withConfig:configModel];
        if(tmpRatio > [WYPoster checkIfRatioReasonable:configModel]) {
            tmpRatio = [WYPoster checkIfRatioReasonable:configModel];
            tmpPart = configModel.configPart;
        }
//        NSLog(@"%f", [WYPoster checkIfRatioReasonable:configModel]);
    }
    if(tmpPart && tmpPart != configModel.configPart) {
        [configModel refillConfigPart:tmpPart];
    }
    
    return configModel;
}

+ (WYPosterView *)createViewUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel {
    if(!configModel.configPart.lineArray.count) {
        configModel = [WYPoster fillLayoutData:text withConfig:configModel];
    }
    
    WYPosterView *view = [[WYPosterView alloc] initWithConfig:configModel];
    [view setFrame:CGRectMake(0, 0, configModel.width, configModel.height)];
    return view;
}

+ (WYPosterLayer *)createLayerUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel {
    if(!configModel.configPart.lineArray.count) {
        configModel = [WYPoster fillLayoutData:text withConfig:configModel];
    }
    
    WYPosterLayer *layer = [[WYPosterLayer alloc] initWithConfigModel:configModel];
    [layer setFrame:CGRectMake(0, 0, configModel.width, configModel.height)];
    return layer;
}

#pragma mark - Private
+ (CGFloat)checkIfRatioReasonable:(WYPosterConfigModel *)configModel {
    CGFloat ratio = configModel.configPart.width / configModel.configPart.height;
    return fabs(ratio - configModel.ratio) / configModel.ratio;
}

@end
