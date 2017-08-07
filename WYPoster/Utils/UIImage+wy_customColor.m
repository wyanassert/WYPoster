//
//  UIImage+wy_customColor.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/7.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "UIImage+wy_customColor.h"

@implementation UIImage (wy_customColor)

+ (UIImage*)wy_customeColorImage:(UIImage*)anImage color:(UIColor*)color
{
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    const CGFloat *colorComponents;
    colorComponents = CGColorGetComponents(color.CGColor);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue,alpha;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            alpha = * (tmp + 3);
            
            if (alpha!=0) {
                *(tmp + 0) = *(colorComponents + 0)*255;
                *(tmp + 1) = *(colorComponents + 1)*255;
                *(tmp + 2) = *(colorComponents + 2)*255;
                *(tmp + 3) = *(colorComponents + 3)*255;
            }
        }
    }
    
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    //CFRelease(dataProvider);
    CFRelease(data);
    return effectedImage;
}

@end
