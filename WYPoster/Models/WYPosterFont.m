//
//  WYPosterFont.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/7.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYPosterFont.h"
#import "WYEstimateFontSizeManager.h"
#import "UIFont+wy_customFont.h"

@interface WYPosterFont()

@property (nonatomic, strong, readwrite) NSString*         fontName;
@property (nonatomic, assign, readwrite) CGFloat           size;
@property (nonatomic, assign, readwrite) CGFloat           heightPerPoint;
@property (nonatomic, assign, readwrite) CGFloat           widthPerPoint;
@property (nonatomic, assign, readwrite) UIFont            *uiFont;

@end

@implementation WYPosterFont

- (instancetype)initWithFontName:(NSString *)fontName size:(CGFloat)size {
    if(self = [super init]) {
        _fontName = fontName;
        _size = size;
        
        CGSize calSize = [[WYEstimateFontSizeManager shareedInstance] estimateWYPosterFont:self];
        _heightPerPoint = calSize.width / size;
        _widthPerPoint = calSize.height / size;
    }
    return self;
}

- (instancetype)initWithUIFont:(UIFont *)font andFontName:(NSString *)fontName {
    if(self = [super init]) {
        _fontName = fontName;
        _size = font.pointSize;
        NSString *testStr = @"WAY";
        CGRect rect = [testStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
        rect.size.height -= (font.ascender - font.capHeight);
        _heightPerPoint = rect.size.height / _size;
        _widthPerPoint = rect.size.width / (_size * testStr.length);
    }
    return self;
}


#pragma mark - getter
- (UIFont *)uiFont {
    return [UIFont wy_customFontWithName:self.fontName size:self.size];
}


#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        
    }
    _fontName = [aDecoder decodeObjectForKey:@"fontName"];
    _size = [[aDecoder decodeObjectForKey:@"size"] floatValue];
    _heightPerPoint = [[aDecoder decodeObjectForKey:@"heightPerPoint"] floatValue];
    _widthPerPoint = [[aDecoder decodeObjectForKey:@"widthPerPoint"] floatValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.fontName forKey:@"fontName"];
    [aCoder encodeObject:@(self.size) forKey:@"size"];
    [aCoder encodeObject:@(self.heightPerPoint) forKey:@"heightPerPoint"];
    [aCoder encodeObject:@(self.widthPerPoint) forKey:@"widthPerPoint"];
}

@end
