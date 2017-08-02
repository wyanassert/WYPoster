//
//  WYPosterLayer.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/1.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterLayer.h"
#import "WYPosterConfigModel.h"
#import "WYPosterUnitLayer.h"
#import "WYPosterConfigPart.h"
#import "WYPosterConfigLine.h"
#import "WYPosterConfigUnit.h"

@interface WYPosterLayer()

@property (nonatomic, strong) WYPosterConfigModel   *configModel;
@property (nonatomic, strong) NSMutableArray<WYPosterUnitLayer *>         *layerArray;

@end

@implementation WYPosterLayer

- (instancetype)initWithConfigModel:(WYPosterConfigModel *)configModel {
    if (self = [super init]) {
        _configModel = configModel;
        [self configLayer];
    }
    return self;
}

#pragma mark - Private
- (void)configLayer {
    self.frame = CGRectMake(0, 0, self.configModel.height, self.configModel.width);
    CGPoint origin = self.configModel.configPart.origin;
    for (NSUInteger i = 0; i < self.configModel.configPart.lineArray.count; i++) {
        WYPosterConfigLine *line = self.configModel.configPart.lineArray[i];
        CGPoint lineOrigin = CGPointMake(origin.x + line.originX, origin.y);
        origin.y += line.height;
        for(NSUInteger j = 0; j < line.unitArray.count; j++) {
            WYPosterConfigUnit *unit = line.unitArray[j];
            WYPosterUnitLayer *unitLayer = [[WYPosterUnitLayer alloc] initWithConfigUnit:unit];
            unitLayer.frame = CGRectMake(lineOrigin.x, lineOrigin.y, unit.width, unit.height);
            lineOrigin.x += unit.width;
            [self addSublayer:unitLayer];
            [self.layerArray addObject:unitLayer];
        }
    }
}


#pragma mark - Getter
- (NSMutableArray<WYPosterUnitLayer *> *)layerArray {
    if(!_layerArray) {
        _layerArray = [NSMutableArray array];
    }
    return _layerArray;
}

@end
