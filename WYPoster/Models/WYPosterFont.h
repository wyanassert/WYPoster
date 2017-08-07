//
//  WYPosterFont.h
//  WYPoster
//
//  Created by wyan assert on 2017/8/7.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WYPosterFont : NSObject <NSSecureCoding>

@property (nonatomic, strong, readonly) NSString*         fontName;
@property (nonatomic, assign, readonly) CGFloat           size;
@property (nonatomic, assign, readonly) CGFloat           heightPerPoint;
@property (nonatomic, assign, readonly) CGFloat           widthPerPoint;
@property (nonatomic, assign, readonly) UIFont            *uiFont;

- (instancetype)initWithFontName:(NSString *)fontName size:(CGFloat)size;

- (instancetype)initWithUIFont:(UIFont *)font andFontName:(NSString *)fontName;

@end
