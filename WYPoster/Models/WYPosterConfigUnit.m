//
//  WYPosterConfigUnit.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigUnit.h"
#import "WYPosterConfigLine.h"

CGFloat kHeightScale = 0.9;
CGFloat kWidthScale = 0.95;

@interface WYPosterConfigUnit()

@property (nonatomic, assign, readwrite) WYPosterConfigUnitType unitType;
@property (nonatomic, assign, readwrite) NSUInteger             length;
@property (nonatomic, assign, readwrite) CGFloat                width;
@property (nonatomic, assign, readwrite) CGFloat                height;

@property (nonatomic, strong, readwrite) NSString               *word;
@property (nonatomic, strong, readwrite) UIFont                 *font;

@property (nonatomic, strong, readwrite) NSArray<NSArray<NSString *> *> *multiWords;
@property (nonatomic, strong, readwrite) NSArray<NSArray<UIFont   *> *> *multiFont;
@property (nonatomic, strong, readwrite) NSMutableArray<WYPosterConfigLine *>  *lineArray;

@end

@implementation WYPosterConfigUnit

@synthesize scale = _scale;

- (instancetype)initWithWord:(NSString *)word font:(UIFont *)font {
    if(self = [super init]) {
        _unitType = WYPosterConfigUnitTypeNormal;
        _length = word.length;
        _word = word;
        _font = font;
        CGRect rect = [word boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        _width = rect.size.width / (word.length) * (word.length + 1) * self.scale * kWidthScale;
        _height = rect.size.height * self.scale * kHeightScale;
    }
    return self;
}

- (instancetype)initWithWords:(NSArray<NSArray<NSString *> *> *)multiWords fonts:(NSArray<NSArray<UIFont *> *> *)multiFont {
    if(self = [super init]) {
        _unitType = WYPosterConfigUnitTypeMultiLine;
        _multiWords = multiWords;
        _multiFont = multiFont;
        NSUInteger totalLength = 0;
        for (NSUInteger i = 0; i < multiWords.count && i < multiFont.count; i++) {
            NSArray<NSString *> *wordArray = multiWords[i];
            NSArray<UIFont *> *fontArray =multiFont[i];
            WYPosterConfigLine *line = [[WYPosterConfigLine alloc] init];
            for(NSUInteger j = 0; j < wordArray.count && j < fontArray.count; j++) {
                NSString *str = [wordArray objectAtIndex:j];
                UIFont *font = [fontArray objectAtIndex:j];
                [line addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:str font:font]];
            }
            totalLength += line.length;
            if(line.length) {
                [self.lineArray addObject:line];
            }
        }
        
        for(WYPosterConfigLine *line in self.lineArray) {
            line.scale = 1 - line.scale * ((CGFloat)line.length) / totalLength - (self.lineArray.count - 2) / ((CGFloat)self.lineArray.count);
            _width = MAX(_width, line.width);
            _height += line.height;
        }
    }
    return self;
}

#pragma mark - Getter
- (CGFloat)scale {
    if(0 == _scale) {
        _scale = 1;
    }
    return _scale;
}

- (NSMutableArray<WYPosterConfigLine *> *)lineArray {
    if(!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

#pragma mark - Setter
- (void)setScale:(CGFloat)scale {
    if(self.unitType == WYPosterConfigUnitTypeNormal) {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize * scale / self.scale];
        _font = font;
        CGRect rect = [self.word boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
        _width = rect.size.width / (self.word.length) * (self.word.length + 1) * kWidthScale;
        _height = rect.size.height * kHeightScale;
        
        _scale = scale;
    }
}

@end
