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

@interface WYPosterUnitLayer()

@property (nonatomic, strong) WYPosterConfigUnit         *configUnit;

@end

@implementation WYPosterUnitLayer

- (instancetype)initWithConfigUnit:(WYPosterConfigUnit *)configUnit {
    if(self = [super init]) {
        _configUnit = configUnit;
        [self configLayer];
    }
    return self;
}

- (void)configLayer {
    if(self.configUnit.unitType == WYPosterConfigUnitTypeImage) {
        self.contents = (__bridge id)self.configUnit.image.CGImage;
        self.contentsGravity = kCAGravityResizeAspect;
        if(self.configUnit.oritention == UIImageOrientationDown) {
            self.affineTransform = CGAffineTransformMakeScale(1, -1);
        } else if (self.configUnit.oritention == WYPosterConfigUintImageRight) {
            self.affineTransform = CGAffineTransformMakeScale(-1, 1);
        }
    } else if (self.configUnit.unitType == WYPosterConfigUnitTypeNormal) {
        CATextLayer *textLayer = [CATextLayer layer];
        [textLayer setFrame:CGRectMake(0, self.configUnit.font.capHeight - self.configUnit.font.ascender, self.configUnit.width, self.configUnit.height + self.configUnit.font.ascender - self.configUnit.font.capHeight)];
        [self addSublayer:textLayer];
        textLayer.foregroundColor = [UIColor redColor].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.wrapped = YES;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        CFStringRef fontName = (__bridge CFStringRef)self.configUnit.font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textLayer.font = fontRef;
        textLayer.fontSize = self.configUnit.font.pointSize;
        CGFontRelease(fontRef);
        
        textLayer.string = self.configUnit.word;
        
    } else if (self.configUnit.unitType == WYPosterConfigUnitTypeMultiLine) {
        WYPosterLayer *layer = [[WYPosterLayer alloc] initWithConfigpart:self.configUnit.configPart];
        [layer setFrame:CGRectMake(0, 0, self.configUnit.width, self.configUnit.height)];
        [self addSublayer:layer];
    }
}

@end
