//
//  WYPosterConfigModel.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigModel.h"
#import "WYPosterConfigPart.h"

@interface WYPosterConfigModel()

//@property (nonatomic, strong, readwrite) NSMutableArray<WYPosterConfigLine*> *lineArray;
@property (nonatomic, assign, readwrite) CGFloat            width;
@property (nonatomic, assign, readwrite) CGFloat            height;
@property (nonatomic, strong, readwrite) WYPosterConfigPart *configPart;

@end

@implementation WYPosterConfigModel

@synthesize scale = _scale;

- (void)resizeToPrefer {
    CGFloat scale = MIN(self.preferWidth / self.configPart.width, self.preferWidth * self.ratio / self.configPart.height);
    self.configPart.scale = scale;
    _width = self.configPart.width;
    _height = self.configPart.height;
}

- (void)adjustAligment {
    [self.configPart calOriginXForPerLine:self.alignment];
}

#pragma mark - Setter
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self resizeToPrefer];
}

#pragma mark - Getter
- (WYPosterConfigPart *)configPart {
    if(!_configPart) {
        _configPart = [[WYPosterConfigPart alloc] init];
    }
    return _configPart;
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

@end
