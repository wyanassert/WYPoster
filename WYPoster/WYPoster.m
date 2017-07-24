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
    UIFont *font= configModel.fontArray[0];
    NSDictionary* dic = @{
                          NSFontAttributeName:font,
                          };
    CGSize characterSize = [@"A" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    NSUInteger avg = ceil(sqrt(configModel.ratio * characterSize.height / characterSize.width * text.length) * 1.2);
    
    [WYPosterParticiple spliteWordArray:wordArray lengthPerLine:avg withConfig:configModel];
    
    return configModel;
}

+ (UIView *)createViewUsingText:(NSString *)text withConfigModel:(WYPosterConfigModel *)configModel {
    if(!configModel.lineArray.count) {
        configModel = [WYPoster fillLayoutData:text withConfig:configModel];
    }
    
    return [[WYPosterView alloc] initWithConfig:configModel];
}

@end
