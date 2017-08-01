//
//  WYPosterPartView.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/26.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterPartView.h"
#import "WYPosterConfigPart.h"
#import "WYPosterLineView.h"
#import "WYPosterConfigLine.h"
#import "Masonry.h"

@interface WYPosterPartView()

@property (nonatomic, strong) WYPosterConfigPart         *part;
@property (nonatomic, strong) NSMutableArray<WYPosterLineView *>         *lineViewArray;

@end

@implementation WYPosterPartView

- (instancetype)initWithPosterPart:(WYPosterConfigPart *)part {
    if(self = [super init]) {
        _part = part;
        [self configView];
    }
    return self;
}

- (void)reloadPartConfig {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.part.height);
        make.width.mas_equalTo(self.part.width);
    }];
    for(WYPosterLineView *lineView in self.lineViewArray) {
        [lineView reloadLineConfig];
    }
}

- (void)configView {
    [self.lineViewArray removeAllObjects];
    __weak typeof(self)weakSelf = self;
    [self.part.lineArray enumerateObjectsUsingBlock:^(WYPosterConfigLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf)self = weakSelf;
        WYPosterLineView *lineView = [[WYPosterLineView alloc] initWithPosetrLine:obj];
        [self.lineViewArray addObject:lineView];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(idx == 0) {
                make.top.equalTo(self);
            } else {
                make.top.equalTo(self.lineViewArray[idx - 1].mas_bottom);
            }
            make.height.mas_equalTo(obj.height);
            make.width.mas_equalTo(obj.width);
            make.left.mas_equalTo(obj.originX);
        }];
    }];
}

#pragma mark - Getter
- (NSMutableArray<WYPosterLineView *> *)lineViewArray {
    if(!_lineViewArray) {
        _lineViewArray = [NSMutableArray array];
    }
    return _lineViewArray;
}


@end
