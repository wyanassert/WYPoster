//
//  WYPosterUnitLayer.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/2.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterUnitLayer.h"
#import "WYPosterConfigUnit.h"
#import "WYPosterLayer.h"
#import "UIImage+wy_customColor.h"

@interface WYPosterUnitLayer()

@property (nonatomic, strong) WYPosterConfigUnit         *configUnit;
@property (nonatomic, strong) CATextLayer         *textLayer;
@property (nonatomic, strong) WYPosterLayer         *partLayer;

@end

@implementation WYPosterUnitLayer

- (instancetype)initWithConfigUnit:(WYPosterConfigUnit *)configUnit {
    if(self = [super init]) {
        _configUnit = configUnit;
        [self configLayer];
//        self.borderColor = [UIColor redColor].CGColor;
//        self.borderWidth = 1;
    }
    return self;
}

- (void)configLayer {
    if(self.configUnit.unitType == WYPosterConfigUnitTypeImage) {
        self.contents = (__bridge id)[UIImage wy_customeColorImage:self.configUnit.image color:self.configUnit.color].CGImage;
        self.contentsGravity = kCAGravityResizeAspect;
        if(self.configUnit.oritention == UIImageOrientationDown) {
            self.affineTransform = CGAffineTransformMakeScale(1, -1);
        } else if (self.configUnit.oritention == WYPosterConfigUintImageRight) {
            self.affineTransform = CGAffineTransformMakeScale(-1, 1);
        }
    } else if (self.configUnit.unitType == WYPosterConfigUnitTypeNormal) {
        UIFont *font = [self.configUnit.font uiFont];
        self.textLayer = [CATextLayer layer];
        [self.textLayer setFrame:CGRectMake(0, font.capHeight - font.ascender, self.configUnit.width , (self.configUnit.height + font.ascender - font.capHeight) * 1.1)];
        [self addSublayer:self.textLayer];
        self.textLayer.foregroundColor = self.configUnit.color.CGColor;
        self.textLayer.alignmentMode = kCAAlignmentCenter;
        self.textLayer.wrapped = YES;
        self.textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        self.textLayer.font = fontRef;
        self.textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        
        self.textLayer.string = self.configUnit.word;
        
    } else if (self.configUnit.unitType == WYPosterConfigUnitTypeMultiLine) {
        self.partLayer = [[WYPosterLayer alloc] initWithConfigpart:self.configUnit.configPart];
        [self.partLayer setFrame:CGRectMake(0, 0, self.configUnit.width, self.configUnit.height)];
        [self addSublayer:self.partLayer];
    }
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    if (self.configUnit.unitType == WYPosterConfigUnitTypeNormal) {
        UIColor *color = [UIColor blackColor];
        if(colors.count) {
            color = colors.firstObject;
        }
        self.textLayer.foregroundColor = color.CGColor;
    } else if(self.configUnit.unitType == WYPosterConfigUnitTypeMultiLine) {
        [self.partLayer setColor:colors];
    } else if(self.configUnit.unitType == WYPosterConfigUnitTypeImage) {
        UIColor *color = [UIColor blackColor];
        if(colors.count) {
            color = colors.firstObject;
        }
        self.contents = (__bridge id)[UIImage wy_customeColorImage:self.configUnit.image color:color].CGImage;
    }
}

- (void)setShadowOpacity:(CGFloat)opacity blurRadius:(CGFloat)blurRadius color:(UIColor *)color offset:(CGSize)offset {
    self.shadowOpacity = opacity;
    self.shadowRadius = blurRadius;
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
}

@end
