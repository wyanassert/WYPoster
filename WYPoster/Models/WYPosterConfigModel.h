//
//  WYPosterConfigModel.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WYPosterConfigPart;

typedef NS_OPTIONS(NSUInteger, WYPreferLocalMultiLine) {
    WYPreferLocalMultiLineNone         = 0,
    WYPreferLocalMultiLineNormal       = 0x1 << 0,
    WYPreferLocalMultiLineNotFirstLine = 0x1 << 1,
    WYPreferLocalMultiLineNotLastLine  = 0x1 << 2,
    WYPreferLocalMultiLineNotLineHead  = 0x1 << 3,
    WYPreferLocalMultiLineNotLineTail  = 0x1 << 4,
    WYPreferLocalMultiLineNotAdjacent  = 0x1 << 5,
    WYPreferLocalMultiLineNotTwoLine   = 0x1 << 6,
    WYPreferLocalMultiLineNotThreeLine = 0x1 << 7,
};

typedef NS_ENUM(NSUInteger, WYAlignmentType) {
    WYAlignmentCenter = 0,
    WYAlignmentLeft,
    WYAlignmentRight
};

typedef NS_OPTIONS(NSUInteger, WYEmbedImageType) {
    WYEmbedImageTypeNone      = 0,
    WYEmbedImageTypeLeft      = 0x1 << 0,
    WYEmbedImageTypeRight     = 0x1 << 1,
    WYEmbedImageTypeTop       = 0x1 << 2,
    WYEmbedImageTypeBottom    = 0x1 << 3,
};

@interface WYPosterConfigModel : NSObject

@property (nonatomic, assign, readonly) NSUInteger order;
@property (nonatomic, strong, readonly) NSString   *identifier;
@property (nonatomic, strong, readonly) NSString   *name;

@property (nonatomic, assign, readonly) CGFloat    width;
@property (nonatomic, assign, readonly) CGFloat    height;

@property (nonatomic, strong, readonly) WYPosterConfigPart *configPart;
@property (nonatomic, assign) NSUInteger             avgLength;
@property (nonatomic, assign) CGFloat                scale;

@property (nonatomic, assign) WYPreferLocalMultiLine localMultiLine;
@property (nonatomic, assign) NSUInteger             maxMultiLineCountPerLine;
@property (nonatomic, assign) CGFloat                ratio;
@property (nonatomic, assign) CGFloat                preferWidth;
@property (nonatomic, assign) BOOL                   sameWidth;
@property (nonatomic, assign) WYAlignmentType        alignment;
@property (nonatomic, strong) NSArray<UIFont *>      *fontArray;
@property (nonatomic, assign) BOOL                   enableMultiFontInLine;
@property (nonatomic, assign) WYEmbedImageType       embedImageType;
@property (nonatomic, assign) CGFloat                lineInterval;
@property (nonatomic, strong) NSArray<UIColor *>     *defaultColors;
@property (nonatomic, assign) BOOL                   enableMultiColorInLine;
@property (nonatomic, strong) NSArray<NSString *>    *leftRightImageNames;
@property (nonatomic, strong) NSArray<NSString *>    *topBottomImageNames;

- (void)resizeToPrefer;

- (void)adjustAligment;

- (void)cleanConfigPart;

- (void)refillConfigPart:(WYPosterConfigPart *)configpart;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
