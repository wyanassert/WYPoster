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
#import "WYPosterConfigPart.h"

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
    for (NSUInteger i = 0; i < wordArray.count; i++) {
        NSString *tmpStr = [wordArray objectAtIndex:i];
        if(configModel.localMultiLine != WYPreferLocalMultiLineNone &&
           [self shouldApplyMultiLine:wordArray fromIndex:i multiLine:3 currentLine:tmpLine withConfigModel:configModel] &&
           (arc4random() % WYPreferLocalMultiLineCount) <= configModel.localMultiLine) {
            NSArray<NSArray<NSString *> *> *multiWord = @[@[wordArray[i]], @[wordArray[i + 1]], @[wordArray[i + 2]]];
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWords:multiWord fonts:configModel.fontArray]];
            i += 2;
        } else if(configModel.localMultiLine != WYPreferLocalMultiLineNone &&
                  [self shouldApplyMultiLine:wordArray fromIndex:i multiLine:2 currentLine:tmpLine withConfigModel:configModel] &&
                  (arc4random() % WYPreferLocalMultiLineCount) <= configModel.localMultiLine) {
            NSArray<NSArray<NSString *> *> *multiWord = @[@[wordArray[i]], @[wordArray[i + 1]]];
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWords:multiWord fonts:configModel.fontArray]];
            i ++;
        } else if(tmpLine.length + tmpStr.length < configModel.avgLength) {
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
            
        } else {
            if(tmpLine.length > 0) {
                tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
                [configModel.configPart addConfigLine:tmpLine];
                tmpLine = [WYPosterConfigLine new];
            }
            [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
        }
    }
    if(tmpLine.length > 0) {
        tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
        [configModel.configPart addConfigLine:tmpLine];
    }
    
    [configModel resizeToPrefer];
    
    return configModel;
}


#pragma mark - Private
+ (BOOL)shouldApplyMultiLine:(NSArray<NSString *> *)wordArray fromIndex:(NSUInteger)index multiLine:(NSUInteger)row currentLine:(WYPosterConfigLine *)currentLine withConfigModel:(WYPosterConfigModel *)configModel {
    if(index + row >= wordArray.count) {
        return NO;
    }
    NSMutableArray<NSString *> *multiLineWords = [NSMutableArray array];
    NSUInteger i = row;
    NSUInteger maxLen = 0;
    NSUInteger minLen = NSUIntegerMax;
    while (i--) {
        [multiLineWords addObject:wordArray[index + row - i - 1]];
        maxLen = MAX(maxLen, wordArray[index + row - i - 1].length);
        minLen = MIN(minLen, wordArray[index + row - i - 1].length);
    }
    if(maxLen - minLen > ceil(maxLen * 0.2)) {
        return NO;
    } else if (currentLine.length > 0 && currentLine.length + ceil((CGFloat) maxLen) / multiLineWords.count > configModel.avgLength) {
        return NO;
    } else if (currentLine.length + ceil((CGFloat) maxLen) / multiLineWords.count + wordArray[index + row].length > configModel.avgLength) {
        return NO;
    }
    return YES;
}

@end
