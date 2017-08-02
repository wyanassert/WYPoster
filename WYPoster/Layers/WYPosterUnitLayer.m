//
//  WYPosterUnitLayer.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/2.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterUnitLayer.h"

@interface WYPosterUnitLayer()

@property (nonatomic, strong) WYPosterConfigUnit         *configUnit;

@end

@implementation WYPosterUnitLayer

- (instancetype)initWithConfigUnit:(WYPosterConfigUnit *)configUnit {
    if(self = [super init]) {
        _configUnit = configUnit;
        self.backgroundColor = [UIColor colorWithRed:((arc4random() % 10) / 9.0) green:0.3 blue:0.2 alpha:1].CGColor;
    }
    return self;
}

@end
