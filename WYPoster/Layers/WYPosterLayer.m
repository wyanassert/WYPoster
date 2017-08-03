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

@property (nonatomic, strong) CALayer         *containerLayer;
@property (nonatomic, strong) CAGradientLayer         *gradientLayer;

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

- (void)setGradientColor:(NSArray<UIColor *> *)colors percentage:(CGFloat)percentage rotate:(CGFloat)rotate {
    if(percentage > 1 || percentage < 0) {
        percentage = fabs(percentage);
        percentage -= floor(percentage);
    }
    UIImage *image = [self getSnapShot:self.containerLayer];
    NSMutableArray *gradientColors = [NSMutableArray array];
    for(UIColor *color in colors) {
        [gradientColors addObject:(id)color.CGColor];
    }
    self.gradientLayer.colors = gradientColors;
    self.gradientLayer.locations = @[@(pow(percentage, 2)), @(sqrt(percentage))];
    
    CGFloat l = 0;
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    if(rotate >= 0 && rotate < M_PI_2) {
        l = 0.5 * sqrt(2) * sin(rotate) / sin(rotate + M_PI_4);
        startPoint = CGPointMake(0, l);
        endPoint = CGPointMake(1, 1 - l);
    } else if(rotate >= M_PI_2 && rotate < M_PI) {
        rotate -= M_PI_2;
        l = 0.5 * sqrt(2) * sin(rotate) / sin(rotate + M_PI_4);
        startPoint = CGPointMake(l, 1);
        endPoint = CGPointMake(1 - l, 0);
    } else if (rotate >= M_PI && rotate < M_PI_2 * 3) {
        rotate -= M_PI;
        l = 0.5 * sqrt(2) * sin(rotate) / sin(rotate + M_PI_4);
        startPoint = CGPointMake(1, 1 - l);
        endPoint = CGPointMake(0, l);
    } else if(rotate >= M_PI_2 * 3 && rotate <= M_PI * 2) {
        rotate -= M_PI_2 * 3;
        l = 0.5 * sqrt(2) * sin(rotate) / sin(rotate + M_PI_4);
        startPoint = CGPointMake(1 - l, 0);
        endPoint = CGPointMake(l , 1);
    }
    self.gradientLayer.startPoint = startPoint;
    self.gradientLayer.endPoint = endPoint;
    
    CALayer* tmpLayer = CALayer.layer;
    tmpLayer.frame = self.containerLayer.bounds;
    tmpLayer.contentsGravity = kCAGravityResizeAspect;
    tmpLayer.contents = (__bridge id)(image.CGImage);
    
    self.gradientLayer.mask = tmpLayer;
    self.gradientLayer.hidden = NO;
}

- (void)closeGradient {
    self.containerLayer.hidden = NO;
    self.gradientLayer.hidden = YES;
}

#pragma mark - Private
- (void)configLayer {
    self.frame = CGRectMake(0, 0, self.configPart.height, self.configPart.width);
    [self addSublayer:self.containerLayer];
    [self addSublayer:self.gradientLayer];
    self.gradientLayer.hidden = YES;
    CGPoint origin = self.configPart.origin;
    for (NSUInteger i = 0; i < self.configPart.lineArray.count; i++) {
        WYPosterConfigLine *line = self.configPart.lineArray[i];
        origin.y = line.origin.y + self.configPart.origin.y;
        CGPoint lineOrigin = CGPointMake(origin.x + line.origin.x, origin.y);
        for(NSUInteger j = 0; j < line.unitArray.count; j++) {
            WYPosterConfigUnit *unit = line.unitArray[j];
            WYPosterUnitLayer *unitLayer = [[WYPosterUnitLayer alloc] initWithConfigUnit:unit];
            unitLayer.frame = CGRectMake(lineOrigin.x, lineOrigin.y + unit.originY, unit.width, unit.height);
            lineOrigin.x += unit.width;
            [self.containerLayer addSublayer:unitLayer];
            [self.layerArray addObject:unitLayer];
        }
    }
}

- (UIImage*) getSnapShot:(CALayer*)layer
{
    CGSize size = CGSizeMake(ceilf(layer.bounds.size.width), ceilf(layer.bounds.size.height));
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [layer renderInContext:context];
    CGContextRestoreGState(context);
    UIImage* snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snap;
}

#pragma mark - Setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.containerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.gradientLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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

- (CALayer *)containerLayer {
    if(!_containerLayer) {
        _containerLayer = [CALayer layer];
    }
    return _containerLayer;
}

- (CAGradientLayer *)gradientLayer {
    if(!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 1);
    }
    return _gradientLayer;
}

@end
