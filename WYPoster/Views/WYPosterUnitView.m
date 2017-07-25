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

- (void)reloadUnitConfig {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.unit.height);
        make.width.mas_equalTo(self.unit.width);
    }];
    
    self.label.font = self.unit.font;
}

- (void)configView {
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
        lb.textAlignment = NSTextAlignmentCenter;
        _label = lb;
    }
    return _label;
}

@end
