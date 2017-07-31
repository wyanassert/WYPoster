//
//  WYPosterConfigLine.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigLine.h"
#import "WYPosterConfigUnit.h"

@interface WYPosterConfigLine()

@property (nonatomic, strong, readwrite) NSMutableArray<WYPosterConfigUnit *> *unitArray;
@property (nonatomic, assign, readwrite) NSUInteger length;
@property (nonatomic, assign, readwrite) CGFloat    width;
@property (nonatomic, assign, readwrite) CGFloat    height;

@end

@implementation WYPosterConfigLine

@synthesize scale = _scale;

- (void)addConfigUnit:(WYPosterConfigUnit *)unit {
    [self.unitArray addObject:unit];
    if(self.length != 0) {
        _length ++;
    }
    _length += unit.length;
    _width += unit.width;
    _height = MAX(_height, unit.height);
    _baseCount += unit.baseCount;
}

#pragma mark - Getter

- (NSMutableArray<WYPosterConfigUnit *> *)unitArray {
    if(!_unitArray) {
        _unitArray = [NSMutableArray array];
    }
    return _unitArray;
}

- (CGFloat)scale {
    if(0 == _scale) {
        _scale = 1;
    }
    return _scale;
}

#pragma mark - Setter
- (void)setScale:(CGFloat)scale {
    _width *= scale / self.scale;
    _height *= scale / self.scale;
    _scale = scale;
    for(WYPosterConfigUnit *unit in self.unitArray) {
        unit.scale = scale;
    }
}

@end
