//
//  WYPosterConfigUnit.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterConfigUnit.h"

CGFloat kHeightScale = 0.9;
CGFloat kWidthScale = 0.95;

@interface WYPosterConfigUnit()

@property (nonatomic, assign, readwrite) WYPosterConfigUnitType unitType;
@property (nonatomic, assign, readwrite) NSUInteger             length;
@property (nonatomic, strong, readwrite) NSString               *word;
@property (nonatomic, strong, readwrite) UIFont                 *font;
@property (nonatomic, assign, readwrite) CGFloat                width;
@property (nonatomic, assign, readwrite) CGFloat                height;

@end

@implementation WYPosterConfigUnit

@synthesize scale = _scale;

- (instancetype)initWithWord:(NSString *)word font:(UIFont *)font {
    if(self = [super init]) {
        _unitType = WYPosterConfigUnitTypeNormal;
        _length = word.length;
        _word = word;
        _font = font;
        CGRect rect = [word boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        _width = rect.size.width / (word.length) * (word.length + 1) * self.scale * kWidthScale;
        _height = rect.size.height * self.scale * kHeightScale;
    }
    return self;
}

#pragma mark - Getter
- (CGFloat)scale {
    if(0 == _scale) {
        _scale = 1;
    }
    return _scale;
}

#pragma mark - Setter
- (void)setScale:(CGFloat)scale {
    UIFont *font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize * scale / self.scale];
    _font = font;
    CGRect rect = [self.word boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    _width = rect.size.width / (self.word.length) * (self.word.length + 1) * kWidthScale;
    _height = rect.size.height * kHeightScale;
    
    _scale = scale;
}

@end
