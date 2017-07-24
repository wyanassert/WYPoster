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
@property (nonatomic, assign, readwrite) NSUInteger                  length;

@end

@implementation WYPosterConfigLine

- (void)addConfigUnit:(WYPosterConfigUnit *)unit {
    [self.unitArray addObject:unit];
    if(self.length != 0) {
        _length ++;
    }
    _length += unit.length;
}

#pragma mark - Getter
- (NSMutableArray<WYPosterConfigUnit *> *)unitArray {
    if(!_unitArray) {
        _unitArray = [NSMutableArray array];
    }
    return _unitArray;
}

@end
