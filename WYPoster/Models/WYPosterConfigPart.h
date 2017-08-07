//
//  WYPosterConfigPart.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/26.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WYPosterConfigModel.h"

@class WYPosterConfigLine;

@interface WYPosterConfigPart : NSObject

@property (nonatomic, strong, readonly ) NSMutableArray<WYPosterConfigLine*> *lineArray;
@property (nonatomic, assign, readonly ) NSUInteger         baseCount;
@property (nonatomic, assign, readonly ) CGPoint            origin;
@property (nonatomic, assign, readonly ) CGFloat            width;
@property (nonatomic, assign, readonly ) CGFloat            height;

@property (nonatomic, strong, readwrite) NSArray<WYPosterFont*> *fontArray;
@property (nonatomic, assign, readwrite) CGFloat            scale;
@property (nonatomic, assign, readwrite) CGFloat            lineInterval;

- (void)addConfigLine:(WYPosterConfigLine *)line;

- (void)appendPrefixLine:(WYPosterConfigLine *)line;

- (void)appendSuffixLine:(WYPosterConfigLine *)line;

- (void)keepSameWidth;

- (void)calOriginXForPerLine:(WYAlignmentType)aligmentType withLineInterval:(CGFloat)lineInterval;

- (void)adjustOrigin:(CGPoint)origin;

@end
