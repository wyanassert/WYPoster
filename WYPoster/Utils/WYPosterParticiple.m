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

+ (WYPosterConfigModel *)spliteWordArray:(NSArray<NSString *> *)wordArray lengthPerLine:(NSUInteger)avg withConfig:(WYPosterConfigModel *)configModel {
    NSMutableArray *array = [NSMutableArray array];
    
    configModel.avgLength = avg;
    
    WYPosterConfigLine *tmpLine = [WYPosterConfigLine new];
    for(NSString *tmpStr in wordArray) {
        if(tmpLine.length + tmpStr.length < avg) {
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
            
        } else {
            if(tmpLine.length > 0) {
                [array addObject:tmpLine];
                tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
                tmpLine = [WYPosterConfigLine new];
            }
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
        }
    }
    if(tmpLine.length > 0) {
        [array addObject:tmpLine];
        tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
    }
    
    [configModel configureWithLineArray:[array copy]];
    
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
