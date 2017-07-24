//
//  WYPosterConfigUnit.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigUnit.h"

@interface WYPosterConfigUnit()

@property (nonatomic, assign, readwrite) WYPosterConfigUnitType unitType;
@property (nonatomic, assign, readwrite) NSUInteger             length;
@property (nonatomic, strong, readwrite) NSString         *word;

@end

@implementation WYPosterConfigUnit

- (instancetype)initWithWord:(NSString *)word {
    if(self = [super init]) {
        _unitType = WYPosterConfigUnitTypeNormal;
        _length = word.length;
        _word = word;
    }
    return self;
}

@end
