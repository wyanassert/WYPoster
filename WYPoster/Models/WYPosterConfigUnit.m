//
//  WYPosterConfigUnit.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigUnit.h"
#import "WYPosterConfigLine.h"
#import "WYPosterConfigPart.h"

CGFloat kHeightScale = 1;
CGFloat kWidthScale = 1.15;

@interface WYPosterConfigUnit()

@property (nonatomic, assign, readwrite) WYPosterConfigUnitType unitType;
@property (nonatomic, assign, readwrite) NSUInteger             length;
@property (nonatomic, assign, readwrite) CGFloat                width;
@property (nonatomic, assign, readwrite) CGFloat                height;

@property (nonatomic, strong, readwrite) NSString               *word;
@property (nonatomic, strong, readwrite) UIFont                 *font;
@property (nonatomic, strong, readwrite) UIColor                *color;

@property (nonatomic, strong, readwrite) NSArray<NSArray<NSString *> *> *multiWords;
@property (nonatomic, strong, readwrite) NSArray<UIFont *>              *multiFont;
@property (nonatomic, strong, readwrite) WYPosterConfigPart             *configPart;

@end

@implementation WYPosterConfigUnit

@synthesize scale = _scale;

- (instancetype)initWithWord:(NSString *)word font:(UIFont *)font color:(UIColor *)color {
    if(self = [super init]) {
        _unitType = WYPosterConfigUnitTypeNormal;
        _length = word.length;
        _word = word;
        _font = font;
        _color = color;
        CGRect rect = [word boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        _width = rect.size.width / (word.length) * (word.length + 1) * self.scale * kWidthScale;
        _height = rect.size.height * self.scale * kHeightScale;
    }
    return self;
}

- (instancetype)initWithWords:(NSArray<NSArray<NSString *> *> *)multiWords fonts:(NSArray<UIFont *> *)multiFont colors:(NSArray<UIColor *> *)colorArray {
    if(self = [super init]) {
        _unitType = WYPosterConfigUnitTypeMultiLine;
        _multiWords = multiWords;
        _multiFont = multiFont;
        NSUInteger totalLength = 0;
        for (NSUInteger i = 0; i < multiWords.count; i++) {
            NSArray<NSString *> *wordArray = multiWords[i];
            WYPosterConfigLine *line = [[WYPosterConfigLine alloc] init];
            UIColor *color = [UIColor blackColor];
            if(colorArray.count) {
                color = colorArray[arc4random() % [colorArray count]];
            }
            for(NSUInteger j = 0; j < wordArray.count; j++) {
                NSString *str = [wordArray objectAtIndex:j];
                [line addConfigUnit:[[WYPosterConfigUnit alloc] initWithWord:str font:[multiFont firstObject] color:color]];
            }
            totalLength += line.length;
            if(line.length) {
                [self.configPart addConfigLine:line];
            }
        }
        
        for(WYPosterConfigLine *line in self.configPart.lineArray) {
            line.scale = 1 - line.scale * ((CGFloat)line.length) / totalLength - (self.configPart.lineArray.count - 2) / ((CGFloat)self.configPart.lineArray.count);
            _width = MAX(_width, line.width);
            _height += line.height;
        }
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image color:(UIColor *)color {
    if(self = [super init]) {
        _image = image;
        _color = color;
        _unitType = WYPosterConfigUnitTypeImage;
        _width = image.size.width;
        _height = image.size.height;
        _length = 2;
    }
    return self;
}

#pragma mark - Getter
- (NSUInteger)baseCount {
    if(self.unitType == WYPosterConfigUnitTypeMultiLine) {
        return self.configPart.baseCount;
    } else if(self.unitType == WYPosterConfigUnitTypeNormal) {
        return 1;
    } else if(self.unitType == WYPosterConfigUnitTypeImage) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)scale {
    if(0 == _scale) {
        _scale = 1;
    }
    return _scale;
}

- (WYPosterConfigPart *)configPart {
    if(!_configPart) {
        _configPart = [[WYPosterConfigPart alloc] init];
    }
    return _configPart;
}

- (UIColor *)color {
    if(!_color) {
        _color = [UIColor blackColor];
    }
    return _color;
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
        _width = rect.size.width * kWidthScale;
        _height = font.ascender * kHeightScale;
        
        _scale = scale;
    } else if(self.unitType == WYPosterConfigUnitTypeMultiLine) {
        self.configPart.scale = scale / self.scale;
        _width = self.configPart.width;
        _height = self.configPart.height;
        _scale = scale;
    } else if(self.unitType == WYPosterConfigUnitTypeImage) {
        if(_scale == 0) {
            _width = _width * scale / self.scale;
            _height = _height * scale / self.scale;
            _scale = 1;
        } else {
            _width = _width * scale / self.scale;
            _height = _height * scale / self.scale;
            _scale = scale;
        }
    }
}

@end
