//
//  WYPosterParticiple.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterParticiple.h"
#import "WYPosterConfigLine.h"
#import "WYPosterConfigUnit.h"
#import "WYPosterConfigModel.h"

@implementation WYPosterParticiple

+ (NSArray<NSString *> *)getWordFromString:(NSString *)text withConfig:(WYPosterConfigModel *)configModel {
//    NSMutableArray *result = [NSMutableArray array];
    NSCharacterSet *delimiterCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSMutableArray  *result = [NSMutableArray arrayWithArray:[text componentsSeparatedByCharactersInSet:delimiterCharacterSet]];
    for(NSString *string in [result copy]) {
        if(string.length == 0) {
            [result removeObject:string];
        }
    }
    return [result copy];
}

+ (WYPosterConfigModel *)calAvgLengthForConfigModel:(WYPosterConfigModel *)configModel withText:(NSString *)text {
    UIFont *font= configModel.fontArray[0];
    NSDictionary* dic = @{
                          NSFontAttributeName:font,
                          };
    CGSize characterSize = [@"A" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    NSUInteger avg = ceil(sqrt(configModel.ratio * characterSize.height / characterSize.width * text.length) * 1.2);
    configModel.avgLength = avg;
    return configModel;
}

+ (WYPosterConfigModel *)spliteWordArray:(NSArray<NSString *> *)wordArray withConfig:(WYPosterConfigModel *)configModel {
    WYPosterConfigLine *tmpLine = [WYPosterConfigLine new];
    for(NSString *tmpStr in wordArray) {
        if(tmpLine.length + tmpStr.length < configModel.avgLength) {
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
            
        } else {
            if(tmpLine.length > 0) {
                tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
                [configModel addConfigLine:tmpLine];
                tmpLine = [WYPosterConfigLine new];
            }
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
        }
    }
    if(tmpLine.length > 0) {
        tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
        [configModel addConfigLine:tmpLine];
    }
    
    [configModel resizeToPrefer];
    
    for(WYPosterConfigLine *line in configModel.lineArray) {
        NSString *str = [NSString string];
        for(WYPosterConfigUnit * unit in line.unitArray) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@" %@", unit.word]];
        }
        NSLog(@"%@", str);
    }
    
    return configModel;
}

@end
