//
//  UIFont+wy_customFont.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/4.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "UIFont+wy_customFont.h"
#import <CoreText/CoreText.h>

#define WYPosterBundleName @"WYPoster"
#define WYPosterBundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:WYPosterBundleName ofType:@"bundle"]]

@implementation UIFont (wy_customFont)

+ (nullable UIFont *)wy_customFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if(!font) {
        NSString *fontPath = [WYPosterBundle pathForResource:fontName ofType:@"ttf" inDirectory:@"font"];
        if(!fontPath.length) {
            fontPath = [WYPosterBundle pathForResource:fontName ofType:@"otf" inDirectory:@"font"];
        }
        if(fontPath.length) {
            NSURL *fontUrl = [NSURL fileURLWithPath:fontPath];
            CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
            CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
            CGDataProviderRelease(fontDataProvider);
            CTFontManagerRegisterGraphicsFont(fontRef, NULL);
            NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
            font = [UIFont fontWithName:fontName size:fontSize];
            CGFontRelease(fontRef);
        }
    }
    return font;
}

@end
