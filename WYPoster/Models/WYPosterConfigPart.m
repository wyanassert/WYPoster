//
//  WYPosterConfigPart.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/26.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigPart.h"
#import "WYPosterConfigLine.h"

@interface WYPosterConfigPart()

@property (nonatomic, strong, readwrite) NSMutableArray<WYPosterConfigLine*> *lineArray;
@property (nonatomic, assign, readwrite) CGFloat            width;
@property (nonatomic, assign, readwrite) CGFloat            height;

@end

@implementation WYPosterConfigPart

@synthesize scale = _scale;

- (void)addConfigLine:(WYPosterConfigLine *)line {
    [self.lineArray addObject:line];
    _height += line.height;
    _width = MAX(_width, line.width);
    _baseCount += line.baseCount;
}

- (void)appendPrefixLine:(WYPosterConfigLine *)line {
    if(!line.unitArray.count) {
        return ;
    }
    [self.lineArray insertObject:line atIndex:0];
    _height += line.height;
    _width = MAX(_width, line.width);
    _baseCount += line.baseCount;
}

- (void)appendSuffixLine:(WYPosterConfigLine *)line {
    if(!line.unitArray.count) {
        return ;
    }
    [self.lineArray addObject:line];
    _height += line.height;
    _width = MAX(_width, line.width);
    _baseCount += line.baseCount;
}

- (void)keepSameWidth {
    _height = 0;
    _width = 0;
    for(WYPosterConfigLine *line in self.lineArray) {
        line.scale = line.scale * self.lineArray[0].width / line.width;
        _height += line.height;
        _width = MAX(_width, line.width);
    }
}

- (void)calOriginXForPerLine:(WYAlignmentType)aligmentType {
    for(WYPosterConfigLine *line in self.lineArray) {
        switch (aligmentType) {
            case WYAlignmentLeft: {
                [line calOriginX:0];
            }
                break;
            case WYAlignmentRight: {
                [line calOriginX:self.width - line.width];
            }
                break;
            case WYAlignmentCenter: {
                [line calOriginX:(self.width - line.width) / 2];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Setter
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    for (WYPosterConfigLine *line in self.lineArray) {
        line.scale = line.scale * scale;
    }
    _height = 0;
    _width = 0;
    for (WYPosterConfigLine *line in self.lineArray) {
        _height += line.height;
        _width = MAX(_width, line.width);
    }
}


#pragma mark - Getter
- (NSMutableArray<WYPosterConfigLine *> *)lineArray {
    if(!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}

- (CGFloat)scale {
    if(0 == _scale) {
        _scale = 1;
    }
    return _scale;
}

@end
