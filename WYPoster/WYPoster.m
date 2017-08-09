//
//  WYPoster.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPoster.h"
#import "WYPosterConfigModel.h"
#import "WYPosterConfigPart.h"
#import "WYPosterConfigLine.h"
#import "WYPosterParticiple.h"

static NSArray<WYPosterConfigModel *> *defaultConfigs;

#define WYPosterBundleName @"WYPoster"
#define WYPosterBundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:WYPosterBundleName ofType:@"bundle"]]

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

+ (WYPosterLayer *)createLayerUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel {
    if(!configModel.configPart.lineArray.count) {
        configModel = [WYPoster fillLayoutData:text withConfig:configModel];
    }
    
    WYPosterLayer *layer = [[WYPosterLayer alloc] initWithConfigModel:configModel];
    [layer setFrame:CGRectMake(0, 0, configModel.width, configModel.height)];
    return layer;
}

+ (NSArray<WYPosterConfigModel *> *)getAllConfigModels {
    if(!defaultConfigs) {
        NSString *path = [WYPosterBundle pathForResource:@"WYPoster" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *configDict = nil;
        if(data) {
            NSError *error;
            configDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        }
        if([configDict isKindOfClass:[NSDictionary class]] && [configDict objectForKey:@"default"] && [[configDict objectForKey:@"default"] isKindOfClass:[NSArray class]]) {
            NSArray *configJsonArray = [configDict objectForKey:@"default"];
            NSMutableArray<WYPosterConfigModel *> *tmpArray = [NSMutableArray array];
            for(NSDictionary *json in configJsonArray) {
                WYPosterConfigModel *configModel = [[WYPosterConfigModel alloc] initWithDict:json];
                if(configModel) {
                    [tmpArray addObject:configModel];
                }
            }
            defaultConfigs = [tmpArray copy];
        }
    }
    
    return defaultConfigs;
}

+ (NSArray<NSNumber *> *)getAllConfigNumber {
    NSArray<WYPosterConfigModel *> *configArray = [WYPoster getAllConfigModels];
    NSMutableArray *idArray = [NSMutableArray array];
    for (WYPosterConfigModel *config in configArray) {
        [idArray addObject:@(config.order)];
    }
    return [idArray copy];
}

+ (WYPosterConfigModel *)getConfigWithIdNumber:(NSNumber *)number {
    
    NSArray<WYPosterConfigModel *> *configArray = [WYPoster getAllConfigModels];
    for (WYPosterConfigModel *config in configArray) {
        if(config.order == number.unsignedIntegerValue) {
            return config;
        }
    }
    return nil;
}

#pragma mark - Private
+ (CGFloat)checkIfRatioReasonable:(WYPosterConfigModel *)configModel {
    CGFloat ratio = configModel.configPart.width / configModel.configPart.height;
    return fabs(ratio - configModel.ratio) / configModel.ratio;
}

@end
