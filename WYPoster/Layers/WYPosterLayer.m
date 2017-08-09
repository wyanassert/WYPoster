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

@property (nonatomic, strong) WYPosterLayerConfig         *layerConfig;

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
    [self closeGradient];
    if(!colors.count) {
        return ;
    }
    NSArray<UIColor *> *tmpColors = nil;
    UIColor *color = [UIColor blackColor];
    for(WYPosterUnitLayer *unitLayer in self.layerArray) {
        if(colors.count) {
            color = colors[unitLayer.row % colors.count];
        }
        if(self.configModel.enableMultiColorInLine) {
            tmpColors = colors;
        } else {
            tmpColors = @[color];
        }
        [unitLayer setColors:tmpColors];
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
    
    while (rotate > 2 * M_PI || rotate < 0) {
        if(rotate > 2 * M_PI) {
            rotate -= 2 * M_PI;
        } else if (rotate < 0) {
            rotate += 2 * M_PI;
        }
    }
    
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

- (void)setShadowOpacity:(CGFloat)opacity blurRadius:(CGFloat)blurRadius color:(UIColor *)color offset:(CGSize)offset {
    for(WYPosterUnitLayer *unitLayer in self.layerArray) {
        [unitLayer setShadowOpacity:opacity blurRadius:blurRadius color:color offset:offset];
    }
}

- (void)closeGradient {
    self.containerLayer.hidden = NO;
    self.gradientLayer.hidden = YES;
}

- (void)loadLayerConfig:(WYPosterLayerConfig *)layerConfig {
    if(!layerConfig.gradientEnabled) {
        [self closeGradient];
        [self setColor:layerConfig.displayColors];
    } else {
        [self setGradientColor:layerConfig.gradientColors percentage:layerConfig.gradientPercentage rotate:layerConfig.gradientRotateAngel];
    }
    
    if(layerConfig.shadowEnabled) {
        [self setShadowOpacity:layerConfig.shadowOpacity blurRadius:layerConfig.shadowBlurRadius color:layerConfig.shadowColor offset:layerConfig.shadowOffset];
    } else {
        [self setShadowOpacity:0 blurRadius:0 color:[UIColor clearColor] offset:CGSizeZero];
    }
    
    _layerConfig = [layerConfig copy];
}

#pragma mark - Private
- (void)configLayer {
    self.frame = CGRectMake(0, 0, self.configPart.height, self.configPart.width);
    [self addSublayer:self.containerLayer];
    [self addSublayer:self.gradientLayer];
    self.gradientLayer.hidden = YES;
    
    static NSUInteger showCount = 0;
    
    CGPoint origin = self.configPart.origin;
    for (NSUInteger i = 0; i < self.configPart.lineArray.count; i++) {
        WYPosterConfigLine *line = self.configPart.lineArray[i];
        origin.y = line.origin.y + self.configPart.origin.y;
        CGPoint lineOrigin = CGPointMake(origin.x + line.origin.x, origin.y);
        for(NSUInteger j = 0; j < line.unitArray.count; j++) {
            WYPosterConfigUnit *unit = line.unitArray[j];
            WYPosterUnitLayer *unitLayer = [[WYPosterUnitLayer alloc] initWithConfigUnit:unit];
            unitLayer.row = i;
            unitLayer.frame = CGRectMake(lineOrigin.x, lineOrigin.y + unit.originY, unit.width, unit.height);
            lineOrigin.x += unit.width;
            [self.containerLayer addSublayer:unitLayer];
            if(unit.unitType != WYPosterConfigUnitTypeMultiLine) {
                [self showUpAnimationGroup:showCount duration:0.2 layer:unitLayer];
                showCount += unit.baseCount;
            }
            [self.layerArray addObject:unitLayer];
        }
    }
    if(_configModel) {
        showCount = 0;
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

- (void)showUpAnimationGroup:(NSUInteger)i duration:(CGFloat)duration layer:(CALayer *)layer {
    CABasicAnimation* animationOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationOpacity.beginTime = CACurrentMediaTime();
    animationOpacity.duration = (i+1)*duration;
    animationOpacity.removedOnCompletion = YES;
    animationOpacity.fromValue = @0.0f;
    animationOpacity.toValue = @0.0f;
    animationOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animationOpacity forKey:@"opacity"];
    
    CABasicAnimation *animationScaleX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animationScaleX.beginTime = CACurrentMediaTime() + (i+1)*duration;
    animationScaleX.duration = duration;
    animationScaleX.removedOnCompletion = YES;
    animationScaleX.fromValue = @2.0f;
    animationScaleX.toValue = @1.0f;
    animationScaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animationScaleX forKey:@"scaleXIn"];
    
    CABasicAnimation *animationScaleY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animationScaleY.beginTime = CACurrentMediaTime() + (i+1)*duration;
    animationScaleY.duration = duration;
    animationScaleY.removedOnCompletion = YES;
    animationScaleY.fromValue = @2.f;
    animationScaleY.toValue = @1.0f;
    animationScaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animationScaleY forKey:@"scaleYIn"];
    
    CABasicAnimation *animationTranslationY = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animationTranslationY.beginTime = CACurrentMediaTime() + (i+1)*duration;
    animationTranslationY.duration = duration;
    animationTranslationY.removedOnCompletion = YES;
    animationTranslationY.fromValue = @(layer.position.y - 80);
    animationTranslationY.toValue = @(layer.position.y);
    animationTranslationY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animationTranslationY forKey:@"translationYIn"];
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
