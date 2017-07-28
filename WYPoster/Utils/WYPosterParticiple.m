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
        BOOL canApplyMultiLine = NO;
        if(configModel.localMultiLine != WYPreferLocalMultiLineNone && (arc4random() % 5) <= 1) {
            for (NSArray<NSNumber *> *styleArray in [self preSetMultiArray]) {
                if([WYPosterParticiple shouldApplyMultiLine:wordArray fromIndex:i multiStyle:styleArray currentLine:tmpLine withConfigModel:configModel]) {
                    //                    NSArray<NSArray<NSString *> *> *multiWord = @[@[wordArray[i]], @[wordArray[i + 1]]];
                    NSMutableArray<NSArray<NSString *> *> *multiWord = [NSMutableArray array];
                    NSUInteger startIndex = i;
                    for (NSUInteger j = 0; j < styleArray.count; j++) {
                        NSMutableArray<NSString *> *tmpArray = [NSMutableArray array];
                        for (NSUInteger k = 0; k < styleArray[j].unsignedIntegerValue; k++) {
                            [tmpArray addObject:wordArray[startIndex ++]];
                        }
                        [multiWord addObject:[tmpArray copy]];
                    }
                    [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWords:[multiWord copy] fonts:configModel.fontArray]];
                    NSUInteger totalLen = 0;
                    for (NSUInteger j = 0; j < styleArray.count; j++) {
                        totalLen +=styleArray[j].unsignedIntegerValue;
                    }
                    i = i + totalLen - 1;
                    canApplyMultiLine = YES;
                    break;
                }
            }
        }
        if(!canApplyMultiLine) {
            if(tmpLine.length + tmpStr.length < configModel.avgLength) {
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
    }
    if(tmpLine.length > 0) {
        tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
        [configModel.configPart addConfigLine:tmpLine];
    }
    
    if(configModel.sameWidth) {
        [configModel.configPart keepSameWidth];
    }
    
    [configModel resizeToPrefer];
    
    return configModel;
}


#pragma mark - Private
+ (BOOL)shouldApplyMultiLine:(NSArray<NSString *> *)wordArray fromIndex:(NSUInteger)index multiStyle:(NSArray<NSNumber *> *)styleArray currentLine:(WYPosterConfigLine *)currentLine withConfigModel:(WYPosterConfigModel *)configModel {
    if((configModel.localMultiLine & WYPreferLocalMultiLineNotFirstLine && configModel.configPart.lineArray.count == 0) ||
       (configModel.localMultiLine & WYPreferLocalMultiLineNotLineHead && currentLine.length == 0)) {
        return NO;
    }
    NSUInteger endIndex = index;
    for (NSUInteger i = 0; i < styleArray.count; i++) {
        endIndex +=styleArray[i].unsignedIntegerValue;
    }
    if(endIndex >= wordArray.count) {
        return NO;
    }
    NSUInteger startIndex = index;
    NSUInteger maxLen = 0;
    NSUInteger minLen = NSUIntegerMax;
    for(NSUInteger i = 0; i < styleArray.count ; i++) {
        NSUInteger tmpLen = 0;
        for(NSUInteger j = 0; j < styleArray[i].unsignedIntegerValue; j++) {
            tmpLen += wordArray[startIndex++].length;
        }
        maxLen = MAX(tmpLen, maxLen);
        minLen = MIN(tmpLen, minLen);
    }
    if(maxLen - minLen > ceil(maxLen * 0.1 * styleArray.count)) {
        return NO;
    } else if (currentLine.length > 0 && currentLine.length + ceil((CGFloat) maxLen) / styleArray.count > configModel.avgLength) {
        return NO;
    } else if (currentLine.length + ceil((CGFloat) maxLen) / styleArray.count + wordArray[endIndex].length > configModel.avgLength &&
               configModel.localMultiLine & WYPreferLocalMultiLineNotLineTail) {
        return NO;
    } else if (configModel.localMultiLine & WYPreferLocalMultiLineNotLastLine) {
        NSUInteger leftLength = 0;
        BOOL isSattisfied = NO;
        for (NSUInteger i = endIndex; i < wordArray.count; i++) {
            leftLength += wordArray[i].length;
            if(leftLength > configModel.avgLength * 0.6) {
                isSattisfied = YES;
                break;
            }
        }
        if (!isSattisfied) {
            return NO;
        }
    } else if(configModel.localMultiLine & WYPreferLocalMultiLineNotAdjacent && [currentLine.unitArray lastObject].unitType == WYPosterConfigUnitTypeMultiLine) {
        return NO;
    } else if(configModel.localMultiLine & WYPreferLocalMultiLineNotTwoLine && styleArray.count == 2) {
        return NO;
    } else if(configModel.localMultiLine & WYPreferLocalMultiLineNotThreeLine && styleArray.count == 3) {
        return NO;
    }
    
    return YES;
}

+ (NSArray<NSArray<NSNumber *> *> *)preSetMultiArray {
    NSMutableArray<NSArray<NSNumber *> *> *result = [NSMutableArray arrayWithArray:@[
                                                                                     @[@3, @2, @1],
                                                                                     @[@3, @1, @2],
                                                                                     @[@2, @1, @3],
                                                                                     @[@2, @3, @1],
                                                                                     @[@1, @2, @3],
                                                                                     @[@1, @3, @2],
                                                                                     @[@3, @3, @3],
                                                                                     @[@2, @2, @2],
                                                                                     @[@1, @1, @1],
                                                                                     @[@2, @2],
                                                                                     @[@2, @1],
                                                                                     @[@1, @2],
                                                                                     @[@1, @1],
                                                                                     ]];
    for(NSUInteger i = 0; i < result.count; i++) {
        NSUInteger insert = arc4random() % (result.count - 1);
        NSUInteger splite = arc4random() % result.count;
        NSArray<NSNumber *> *obj = [result objectAtIndex:splite];
        [result removeObjectAtIndex:splite];
        [result insertObject:obj atIndex:insert];
    }
    return [result copy];
}

@end
