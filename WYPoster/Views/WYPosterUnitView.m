//
//  WYPosterUnitView.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterUnitView.h"
#import "WYPosterConfigUnit.h"

@interface WYPosterUnitView()

@property (nonatomic, strong) WYPosterConfigUnit         *unit;

@property (nonatomic, strong) UILabel         *label;

@end

@implementation WYPosterUnitView

- (instancetype)initWithPosterUnit:(WYPosterConfigUnit *)unit {
    if(self = [super init]) {
        _unit = unit;
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
}


#pragma mark - Getter
- (UILabel *)label {
    if(!_label) {
        UILabel *lb = [UILabel new];
        lb.text = self.unit.word;
        lb.textColor = [UIColor redColor];
        lb.font = self.unit.font;
        lb.backgroundColor = [UIColor clearColor];
        [lb sizeToFit];
        _label = lb;
    }
    return _label;
}

@end
