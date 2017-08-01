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
    NSLog(@"方差::%f", [WYPosterParticiple calVariance:result]);
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
    WYPosterConfigLine *tmpLine = nil;
    NSUInteger index = 0;
    while (index < wordArray.count) {
        if(configModel.embedImageType & WYEmbedImageTypeLeftRight  && (arc4random() % 10) < 7) {
            tmpLine = [self spliteALineFormMultiLine:wordArray fromIndex:index withConfigModel:configModel presetLength:configModel.avgLength - 7];
            if(tmpLine.unitArray.count) {
                [tmpLine appendPrefixImageUnit:[[WYPosterConfigUnit alloc] initWithImage:[UIImage imageNamed:@"test0"]]];
                [tmpLine appendSuffixImageUnit:[[WYPosterConfigUnit alloc] initWithImage:[UIImage imageNamed:@"test0"]]];
            }
        } else {
            tmpLine = [self spliteALineFormMultiLine:wordArray fromIndex:index withConfigModel:configModel presetLength:configModel.avgLength];
        }

        if(tmpLine.unitArray.count) {
            tmpLine.scale = ((CGFloat)configModel.avgLength) / tmpLine.length;
            [configModel.configPart addConfigLine:tmpLine];
            index += tmpLine.baseCount;
        }
    }
    BOOL shouldEnableTopBottomImage = (arc4random() % 10) < 6 && configModel.embedImageType & WYEmbedImageTypeTopBottom;
    if(shouldEnableTopBottomImage) {
        CGFloat maxFloat = 0;
        for(WYPosterConfigLine *line in configModel.configPart.lineArray) {
            maxFloat = MAX(maxFloat, line.width);
        }
        WYPosterConfigUnit *topUnit = [[WYPosterConfigUnit alloc] initWithImage:[UIImage imageNamed:@"test1"]];
        WYPosterConfigUnit *bottomUnit = [[WYPosterConfigUnit alloc] initWithImage:[UIImage imageNamed:@"test1"]];
        CGFloat scale = maxFloat / topUnit.width;
        topUnit.scale = scale;
        topUnit.oritention = UIImageOrientationUp;
        bottomUnit.scale = scale;
        bottomUnit.oritention = UIImageOrientationDown;
        
        WYPosterConfigLine *topLine = [WYPosterConfigLine new];
        WYPosterConfigLine *bottomLine = [WYPosterConfigLine new];
        
        [topLine decorteTopBottomImageUnit:topUnit];
        [bottomLine decorteTopBottomImageUnit:bottomUnit];
        
        [configModel.configPart appendPrefixLine:topLine];
        [configModel.configPart appendSuffixLine:bottomLine];
    }
    
    if(configModel.sameWidth) {
        [configModel.configPart keepSameWidth];//保持每行一致的宽度
    }
    
    [configModel resizeToPrefer];//整体缩放
    [configModel adjustAligment];//调整对齐
    
    return configModel;
}


#pragma mark - Private
+ (WYPosterConfigLine *)spliteALineFormMultiLine:(NSArray<NSString *> *)wordArray fromIndex:(NSUInteger)index withConfigModel:(WYPosterConfigModel *)configModel presetLength:(CGFloat)presetLength {
    
    WYPosterConfigLine *tmpLine = [WYPosterConfigLine new];
    for (NSUInteger i = index; i < wordArray.count; i++) {
        NSString *tmpStr = [wordArray objectAtIndex:i];
        BOOL canApplyMultiLine = NO;
        if(configModel.localMultiLine != WYPreferLocalMultiLineNone && ((arc4random() % 5) <= 1 || presetLength != configModel.avgLength)) {
            for (NSArray<NSNumber *> *styleArray in [self preSetMultiArray]) {
                if([WYPosterParticiple shouldApplyMultiLine:wordArray fromIndex:i multiStyle:styleArray currentLine:tmpLine withConfigModel:configModel presetLength:presetLength]) {
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
            if(tmpLine.length + tmpStr.length < presetLength) {
                [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
                
            } else {
                if(tmpLine.length > 0) {
                    return tmpLine;
                } else {
                    [tmpLine addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:tmpStr font:configModel.fontArray.firstObject]];
                }
            }
        }
    }
    
    return tmpLine;
}

+ (BOOL)shouldApplyMultiLine:(NSArray<NSString *> *)wordArray fromIndex:(NSUInteger)index multiStyle:(NSArray<NSNumber *> *)styleArray currentLine:(WYPosterConfigLine *)currentLine withConfigModel:(WYPosterConfigModel *)configModel presetLength:(CGFloat)presetLength {
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
    } else if (currentLine.length > 0 && currentLine.length + ceil((CGFloat) maxLen) / styleArray.count > presetLength) {
        return NO;
    } else if (currentLine.length + ceil((CGFloat) maxLen) / styleArray.count + wordArray[endIndex].length > presetLength &&
               configModel.localMultiLine & WYPreferLocalMultiLineNotLineTail) {
        return NO;
    } else if (configModel.localMultiLine & WYPreferLocalMultiLineNotLastLine) {
        NSUInteger leftLength = 0;
        BOOL isSattisfied = NO;
        for (NSUInteger i = endIndex; i < wordArray.count; i++) {
            leftLength += wordArray[i].length;
            if(leftLength > presetLength * 0.6) {
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
                                                                                     @[@3, @3, @2],
                                                                                     @[@3, @2, @3],
                                                                                     @[@2, @3, @3],
                                                                                     @[@3, @3, @3],
                                                                                     @[@2, @2, @2],
                                                                                     @[@1, @1, @1],
                                                                                     @[@3, @3],
                                                                                     @[@3, @2],
                                                                                     @[@2, @3],
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

+ (CGFloat)calVariance:(NSArray<NSString *> *)wordArray {
    if(!wordArray.count) {
        return 0;
    }
    CGFloat totalLen = 0;
    for(NSString *str in wordArray) {
        totalLen += str.length;
    }
    CGFloat avg = totalLen / wordArray.count;
    totalLen = 0;
    for(NSString *str in wordArray) {
        totalLen += pow((str.length - avg), 2);
    }
    
    return sqrt(totalLen / wordArray.count);
}

@end
