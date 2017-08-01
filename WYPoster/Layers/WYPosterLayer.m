//
//  WYPosterLayer.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/1.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterLayer.h"
#import "WYPosterConfigModel.h"

@interface WYPosterLayer()

@property (nonatomic, strong) WYPosterConfigModel   *model;

@end

@implementation WYPosterLayer

- (instancetype)initWithConfigModel:(WYPosterConfigModel *)configModel {
    if (self = [super init]) {
        _model = configModel;
    }
    return self;
}

@end
