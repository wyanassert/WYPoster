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
@property (nonatomic, strong) WYPosterConfigPart    *configPart;
@property (nonatomic, strong) NSMutableArray<WYPosterUnitLayer *>         *layerArray;

@end

@implementation WYPosterLayer

- (instancetype)initWithConfigModel:(WYPosterConfigModel *)configModel {
    if (self = [super init]) {
        _configModel = configModel;
        [self configLayer];
//        self.borderColor = [UIColor blueColor].CGColor;
//        self.borderWidth = 1;
    }
    return self;
}

- (instancetype)initWithConfigpart:(WYPosterConfigPart *)configPart {
    if (self = [super init]) {
        _configPart = configPart;
        [self configLayer];
    }
    return self;
}

- (void)setColor:(NSArray<UIColor *> *)colors {
    UIColor *color = [UIColor blackColor];
    if(colors.count) {
        color = colors.firstObject;
    }
    for(WYPosterUnitLayer *unitLayer in self.layerArray) {
        [unitLayer setColor:color];
    }
}

#pragma mark - Private
- (void)configLayer {
    self.frame = CGRectMake(0, 0, self.configPart.height, self.configPart.width);
    CGPoint origin = self.configPart.origin;
    for (NSUInteger i = 0; i < self.configPart.lineArray.count; i++) {
        WYPosterConfigLine *line = self.configPart.lineArray[i];
        origin.y = line.origin.y + self.configPart.origin.y;
        CGPoint lineOrigin = CGPointMake(origin.x + line.origin.x, origin.y);
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

- (WYPosterConfigPart *)configPart {
    if(!_configPart) {
        return self.configModel.configPart;
    } else {
        return _configPart;
    }
}

@end
