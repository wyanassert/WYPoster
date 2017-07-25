//
//  WYPosterConfigModel.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigModel.h"
#import "WYPosterConfigLine.h"

@interface WYPosterConfigModel()

@property (nonatomic, strong, readwrite) NSMutableArray<WYPosterConfigLine*> *lineArray;
@property (nonatomic, assign, readwrite) CGFloat            width;
@property (nonatomic, assign, readwrite) CGFloat            height;

@end

@implementation WYPosterConfigModel

- (void)addConfigLine:(WYPosterConfigLine *)line {
    [self.lineArray addObject:line];
    _height += line.height;
    _width = MAX(_width, line.width);
}

- (void)resizeToPrefer {
    CGFloat scale = MIN(self.preferWidth / self.width, self.preferWidth * self.ratio / self.height);
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

- (CGFloat)ratio {
    if(0 == _ratio) {
        _ratio = 1;
    }
    return _ratio;
}

- (CGFloat)maxSizeDiff {
    if(0 == _maxSizeDiff) {
        _maxSizeDiff = 2.5;
    }
    return _maxSizeDiff;
}

-(NSArray<UIFont *> *)fontArray {
    if(!_fontArray) {
        _fontArray = @[[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    }
    return _fontArray;
}

- (CGFloat)preferWidth {
    if(0 == _preferWidth) {
        _preferWidth = 200;
    }
    return _preferWidth;
}

@end
