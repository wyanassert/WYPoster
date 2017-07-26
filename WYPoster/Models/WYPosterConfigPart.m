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
