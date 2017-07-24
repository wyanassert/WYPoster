//
//  WYPosterView.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/21.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterView.h"
#import "WYPosterConfigModel.h"
#import "Masonry.h"

@implementation WYPosterView

- (instancetype)initWithConfig:(WYPosterConfigModel *)configModel {
    if(self = [super init]) {
        
    }
    return self;
}

- (CGSize)preferSize {
    if(_preferSize.height == 0 || _preferSize.width == 0) {
        _preferSize = CGSizeMake(100, 100);
    }
    return _preferSize;
}

@end
