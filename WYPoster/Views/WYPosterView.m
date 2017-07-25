//
//  WYPosterView.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/21.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterView.h"
#import "WYPosterConfigModel.h"
#import "WYPosterConfigLine.h"
#import "WYPosterLineView.h"
#import "Masonry.h"

@interface WYPosterView()

@property (nonatomic, strong) WYPosterConfigModel         *configModel;
@property (nonatomic, strong) NSMutableArray<WYPosterLineView *>         *lineViewArray;

@end

@implementation WYPosterView

- (instancetype)initWithConfig:(WYPosterConfigModel *)configModel {
    if(self = [super init]) {
        _configModel = configModel;
        [self configView];
    }
    return self;
}

- (void)configView {
    [self.lineViewArray removeAllObjects];
    __weak typeof(self)weakSelf = self;
    [self.configModel.lineArray enumerateObjectsUsingBlock:^(WYPosterConfigLine * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            make.centerX.equalTo(self);
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
