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
#import "WYPosterUnitView.h"
#import "Masonry.h"

@interface WYPosterLineView()

@property (nonatomic, strong) WYPosterConfigLine         *line;
@property (nonatomic, strong) NSMutableArray<WYPosterUnitView *> *unitViewArrray;

@end

@implementation WYPosterLineView

- (instancetype)initWithPosetrLine:(WYPosterConfigLine *)line {
    if(self = [super init]) {
        _line = line;
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
            make.top.equalTo(self);
            make.height.mas_equalTo(obj.height);
            make.width.mas_equalTo(obj.width);
        }];
    }];
}

- (void)reloadLineConfig {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.line.height);
        make.width.mas_equalTo(self.line.width);
        make.left.mas_equalTo(self.line.originX);
    }];

    for (WYPosterUnitView *unitView in self.unitViewArrray) {
        [unitView reloadUnitConfig];
    }
}

#pragma mark - Getter
- (NSMutableArray<WYPosterUnitView *> *)unitViewArrray {
    if(!_unitViewArrray) {
        _unitViewArrray = [NSMutableArray array];
    }
    return _unitViewArrray;
}

@end
