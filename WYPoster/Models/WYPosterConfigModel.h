//
//  WYPosterConfigModel.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WYPosterConfigLine;

typedef NS_ENUM(NSUInteger, WYPreferLocalMultiLine) {
    WYPreferLocalMultiLineNone = 0,
    WYPreferLocalMultiLineAny
};

typedef NS_ENUM(NSUInteger, WYAlignmentType) {
    WYAlignmentCenter = 0,
    WYAlignmentLeft,
    WYAlignmentRight
};

typedef NS_ENUM(NSUInteger, WYEmbedImageType) {
    WYEmbedImageTypeNone = 0,
    WYEmbedImageTypeTopBottom,
    WYEmbedImageTypeLeftRight
};

@interface WYPosterConfigModel : NSObject

@property (nonatomic, strong, readonly) NSArray<WYPosterConfigLine     *> *lineArray;

@property (nonatomic, assign) WYPreferLocalMultiLine localMultiLine;
@property (nonatomic, assign) WYAlignmentType        alignment;
@property (nonatomic, assign) CGFloat                ratio;
@property (nonatomic, assign) CGFloat                maxSizeDiff;
@property (nonatomic, strong) NSArray<UIFont *>      *fontArray;
@property (nonatomic, assign) NSUInteger             avgLength;

- (WYPosterConfigModel *)configureWithLineArray:(NSArray<WYPosterConfigLine *> *)lineArray;

@end
