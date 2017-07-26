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
#import "WYPosterConfigPart.h"
#import "WYPosterPartView.h"

@interface WYPosterView()

@property (nonatomic, strong) WYPosterConfigModel         *configModel;
@property (nonatomic, strong) WYPosterPartView            *partView;

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
    [self addSubview:self.partView];
    [self.partView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(self.configModel.configPart.height);
        make.width.mas_equalTo(self.configModel.configPart.width);
    }];
}

- (void)reloadConfig {
    [self setFrame:CGRectMake(self.center.x - self.configModel.width / 2,
                              self.center.y - self.configModel.height / 2,
                              self.configModel.width,
                              self.configModel.height)];
    [self.partView reloadPartConfig];
}

- (void)scaleTo:(CGFloat)scale {
    self.configModel.scale = scale;
    [self reloadConfig];
}

#pragma mark - Getter
- (WYPosterPartView *)partView {
    if(!_partView) {
        _partView = [[WYPosterPartView alloc] initWithPosterPart:self.configModel.configPart];
    }
    return _partView;
}


@end
