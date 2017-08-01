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
@property (nonatomic, assign, readonly ) CGFloat            width;
@property (nonatomic, assign, readonly ) CGFloat            height;

@property (nonatomic, strong, readwrite) NSArray<UIFont*>   *fontArray;
@property (nonatomic, assign, readwrite) CGFloat            scale;

- (void)addConfigLine:(WYPosterConfigLine *)line;

- (void)appendPrefixLine:(WYPosterConfigLine *)line;

- (void)appendSuffixLine:(WYPosterConfigLine *)line;

- (void)keepSameWidth;

- (void)calOriginXForPerLine:(WYAlignmentType)aligmentType;

@end
