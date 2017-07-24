//
//  WYPosterConfigModel.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigModel.h"

@interface WYPosterConfigModel() {
    
}

@property (nonatomic, strong, readwrite) NSArray<WYPosterConfigLine*> *lineArray;

@end

@implementation WYPosterConfigModel

- (WYPosterConfigModel *)configureWithLineArray:(NSArray<WYPosterConfigLine *> *)lineArray {
    _lineArray = lineArray;
    return self;
}

#pragma mark - Getter
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

@end
