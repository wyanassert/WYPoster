//
//  WYPosterConfigModel.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigModel.h"
#import "WYPosterConfigPart.h"

#ifndef UIColorFromHexWithAlpha
#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#endif

#ifndef UIColorFromHex
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#endif

@interface WYPosterConfigModel()

//@property (nonatomic, strong, readwrite) NSMutableArray<WYPosterConfigLine*> *lineArray;
@property (nonatomic, assign, readwrite) CGFloat            width;
@property (nonatomic, assign, readwrite) CGFloat            height;
@property (nonatomic, strong, readwrite) WYPosterConfigPart *configPart;

@end

@implementation WYPosterConfigModel

@synthesize scale = _scale;
@synthesize lineInterval = _lineInterval;

- (instancetype)initWithDict:(NSDictionary *)dict {
    if(self = [super init]) {
        _order = [[dict objectForKey:@"order"] unsignedIntegerValue];
        _identifier = [dict objectForKey:@"id"];
        _name = [dict objectForKey:@"name"];

        NSArray *multiLineArray = [dict objectForKey:@"localMultiLine"];
        if([multiLineArray isKindOfClass:[NSArray class]]) {
            _localMultiLine = 0;
            for(NSString *str in multiLineArray) {
                NSDictionary *map = [self multiLineMap];
                NSNumber *multi = [map objectForKey:str];
                if(multi) {
                    _localMultiLine |= [multi unsignedIntegerValue];
                }
            }
        }
        
        _maxMultiLineCountPerLine = [[dict objectForKey:@"maxMultiLineCountPerLine"] unsignedIntegerValue];
        _ratio = [[dict objectForKey:@"ratio"] floatValue];
        _preferWidth = [[dict objectForKey:@"preferWidth"] floatValue];
        _sameWidth = [[dict objectForKey:@"sameWidth"] boolValue];
        
        NSString *tmpAligment = [dict objectForKey:@"alignment"];
        if(tmpAligment.length) {
            NSNumber *aligmentNumber = [self aligmentMap][tmpAligment];
            _alignment = aligmentNumber.unsignedIntegerValue;
        }
        
        NSArray *fontArray = [dict objectForKey:@"fontArray"];
        if([fontArray isKindOfClass:[NSArray class]]) {
            NSMutableArray<WYPosterFont *> *tmpFonArray = [NSMutableArray array];
            for(NSDictionary *dict in fontArray) {
                NSString *fontName = [dict objectForKey:@"name"];
                NSUInteger size = [[dict objectForKey:@"size"] unsignedIntegerValue];
                if(fontName.length && size) {
                    WYPosterFont *font = [[WYPosterFont alloc] initWithFontName:fontName size:size];
                    if(font) {
                        [tmpFonArray addObject:font];
                    }
                }
            }
            _fontArray = [tmpFonArray copy];
        }
        _enableMultiFontInLine = [[dict objectForKey:@"enableMultiFontInLine"] boolValue];
        
//        _embedImageType = [[dict objectForKey:@"embedImageType"] unsignedIntegerValue];
        NSArray *embedImageArray = [dict objectForKey:@"embedImageType"];
        if([embedImageArray isKindOfClass:[NSArray class]]) {
            for (NSString *str in embedImageArray) {
                NSNumber *embedNumber = [self embedImagemap][str];
                if(embedNumber) {
                    _embedImageType |= embedNumber.unsignedIntegerValue;
                }
            }
        }
        
        _lineInterval = [[dict objectForKey:@"lineInterval"] floatValue];
        
        NSArray *colorArray = [dict objectForKey:@"defaultColors"];
        if([colorArray isKindOfClass:[NSArray class]]) {
            NSMutableArray<UIColor *> *tmpColorArray = [NSMutableArray array];
            for(NSString *str in colorArray) {
                unsigned int outVal;
                NSScanner* scanner = [NSScanner scannerWithString:str];
                [scanner scanHexInt:&outVal];
                [tmpColorArray addObject:UIColorFromHex(outVal)];
            }
            _defaultColors = [tmpColorArray copy];
        }
        _enableMultiColorInLine = [[dict objectForKey:@"enableMultiColorInLine"] boolValue];
        
        _leftRightImageNames = [dict objectForKey:@"leftRightImageNames"];
        _topBottomImageNames = [dict objectForKey:@"topBottomImageNames"];
    }
    return self;
}

- (void)resizeToPrefer {
    CGFloat scale = MIN(self.preferWidth / self.configPart.width, (self.preferWidth * self.ratio - self.lineInterval * (self.configPart.lineArray.count - 1)) / self.configPart.height);
    self.configPart.scale = scale;
    _width = self.preferWidth;
    _height = self.preferWidth / self.ratio;
    
    [self adjustAligment];
}

- (void)adjustAligment {
    [self.configPart calOriginXForPerLine:self.alignment withLineInterval:self.lineInterval];
    
    CGFloat originY = (self.preferWidth / self.ratio - self.configPart.height - self.lineInterval * (self.configPart.lineArray.count - 1)) / 2;
    CGFloat originX = 0;
    switch (self.alignment) {
        case WYAlignmentCenter: {
            originX = (self.preferWidth - self.configPart.width) / 2;
        }
            break;
        case WYAlignmentLeft: {
            originX = 0;
        }
            break;
        case WYAlignmentRight: {
            originX = self.preferWidth - self.configPart.width;
        }
            break;
        default:
            break;
    }
    [self.configPart adjustOrigin:CGPointMake(originX, originY)];
}

- (void)cleanConfigPart {
    _configPart = nil;
    _width = 0;
    _height = 0;
    _scale = 1;
    _avgLength = 0;
}

- (void)refillConfigPart:(WYPosterConfigPart *)configpart {
    _configPart = nil;
    _configPart = configpart;
    _scale = 1;
    _width = self.preferWidth;
    _height = self.preferWidth / self.ratio;
}

#pragma mark - Setter
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self resizeToPrefer];
}

- (void)setLineInterval:(CGFloat)lineInterval {
    _lineInterval = lineInterval;
    self.configPart.lineInterval = lineInterval;
}

#pragma mark - Getter
- (WYPosterConfigPart *)configPart {
    if(!_configPart) {
        _configPart = [[WYPosterConfigPart alloc] init];
        _configPart.lineInterval = self.lineInterval;
    }
    return _configPart;
}

- (NSUInteger)maxMultiLineCountPerLine {
    if(0 == _maxMultiLineCountPerLine) {
        _maxMultiLineCountPerLine = 2;
    }
    return _maxMultiLineCountPerLine;
}

- (CGFloat)ratio {
    if(0 == _ratio) {
        _ratio = 1;
    }
    return _ratio;
}

- (NSArray<WYPosterFont *> *)fontArray {
    if(!_fontArray || !_fontArray.count) {
        _fontArray = @[[[WYPosterFont alloc] initWithFontName:[UIFont systemFontOfSize:12].fontName size:12]];
    }
    return _fontArray;
}

- (CGFloat)preferWidth {
    if(0 == _preferWidth) {
        _preferWidth = 200 * self.scale;
    }
    return _preferWidth * self.scale;
}

- (CGFloat)scale {
    if(_scale == 0) {
        _scale = 1;
    }
    return _scale;
}

- (CGFloat)lineInterval {
    if(_lineInterval == 0) {
        _lineInterval = 2;
    }
    return _lineInterval;
}

- (NSArray<UIColor *> *)defaultColors {
    if(!_defaultColors || !_defaultColors.count) {
        _defaultColors = @[[UIColor blackColor]];
    }
    return _defaultColors;
}

- (NSArray<NSString *> *)leftRightImageNames {
    if(!_leftRightImageNames || !_leftRightImageNames.count) {
        _leftRightImageNames = @[@"h000"];
    }
    return _leftRightImageNames;
}

- (NSArray<NSString *> *)topBottomImageNames {
    if(!_topBottomImageNames || !_topBottomImageNames.count) {
        _topBottomImageNames = @[@"v000"];
    }
    return _topBottomImageNames;
}


#pragma mark - Config
- (NSDictionary *)multiLineMap {
    return @{
             @"Normal"       : @(WYPreferLocalMultiLineNormal),
             @"NotFirstLine" : @(WYPreferLocalMultiLineNotFirstLine),
             @"NotLastLine"  : @(WYPreferLocalMultiLineNotLastLine),
             @"NotLineHead"  : @(WYPreferLocalMultiLineNotLineHead),
             @"NotLineTail"  : @(WYPreferLocalMultiLineNotLineTail),
             @"NotAdjacent"  : @(WYPreferLocalMultiLineNotAdjacent),
             @"NotTwoLine"   : @(WYPreferLocalMultiLineNotTwoLine),
             @"NotThreeLine" : @(WYPreferLocalMultiLineNotThreeLine)
             };
}

- (NSDictionary *)aligmentMap {
    return @{
             @"Center" : @(WYAlignmentCenter),
             @"Left"   : @(WYAlignmentLeft),
             @"Right"  : @(WYAlignmentRight)
             };
}

- (NSDictionary *)embedImagemap {
    return @{
             @"None" : @(WYEmbedImageTypeNone),
             @"Left" : @(WYEmbedImageTypeLeft),
             @"Right" : @(WYEmbedImageTypeRight),
             @"Top" : @(WYEmbedImageTypeTop),
             @"Bottom" : @(WYEmbedImageTypeBottom)
             };
}

@end
