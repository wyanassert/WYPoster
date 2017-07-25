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
#import "WYPosterConfigLine.h"
#import "WYPosterParticiple.h"

@implementation WYPoster

+ (WYPosterConfigModel *)fillLayoutData:(NSString *)text withConfig:(WYPosterConfigModel *)configModel {
    NSArray<NSString *> *wordArray = [WYPosterParticiple getWordFromString:text withConfig:configModel];
    [WYPosterParticiple calAvgLengthForConfigModel:configModel withText:text];
    [WYPosterParticiple spliteWordArray:wordArray withConfig:configModel];
    
    return configModel;
}

+ (WYPosterView *)createViewUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel {
    if(!configModel.lineArray.count) {
        configModel = [WYPoster fillLayoutData:text withConfig:configModel];
    }
    
    WYPosterView *view = [[WYPosterView alloc] initWithConfig:configModel];
    [view setFrame:CGRectMake(0, 0, configModel.width, configModel.height)];
    return view;
}

@end
