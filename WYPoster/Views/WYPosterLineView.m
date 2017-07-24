//
//  WYPosterLineView.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterLineView.h"
#import "WYPosterConfigLine.h"
#import "WYPosterConfigUnit.h"

@interface WYPosterLineView()

@property (nonatomic, strong) WYPosterConfigLine         *line;
@property (nonatomic, strong) NSMutableArray<WYPosterUnitView *> *unitViewArrray;

@end

@implementation WYPosterLineView

- (instancetype)initWithPosetrLine:(WYPosterConfigLine *)line {
    if(self = [super init]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    __weak typeof(self)weakSelf = self;
    [self.unitViewArrray removeAllObjects];
    [self.line.unitArray enumerateObjectsUsingBlock:^(WYPosterConfigUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf)self = weakSelf;
        WYPosterUnitView *unitView = [[WYPosterUnitView alloc] initWithPosterUnit:obj];
        [self.unitViewArrray addObject:unitView];
        [self addSubview:unitView];
        [unitView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(idx == 0) {
                make.left.equalTo(self);
            } else {
                make.left.equalTo(self.unitViewArrray[idx - 1].mas_right);
            }
            make.bottom.top.equalTo(self);
            if(idx == self.unitViewArrray.count - 1) {
                make.right.equalTo(self);
            }
        }];
    }];
}

#pragma mark - Getter
- (NSMutableArray<WYPosterUnitView *> *)unitViewArrray {
    if(!_unitViewArrray) {
        _unitViewArrray = [NSMutableArray array];
    }
    return _unitViewArrray;
}

@end
