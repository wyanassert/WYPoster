//
//  WYPosterConfigLine.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WYPosterConfigUnit;

@interface WYPosterConfigLine : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<WYPosterConfigUnit *> *unitArray;
@property (nonatomic, assign, readonly) NSUInteger         baseCount;
@property (nonatomic, assign, readonly) NSUInteger         length;
@property (nonatomic, assign, readonly) CGFloat            originX;
@property (nonatomic, assign, readonly) CGFloat            width;
@property (nonatomic, assign, readonly) CGFloat            height;
@property (nonatomic, assign,         ) CGFloat            scale;

- (void)addConfigUnit:(WYPosterConfigUnit *)unit;

- (void)appendPrefixImageUnit:(WYPosterConfigUnit *)unit;
- (void)appendSuffixImageUnit:(WYPosterConfigUnit *)unit;
- (void)decorteTopBottomImageUnit:(WYPosterConfigUnit *)unit;

- (void)calOriginX:(CGFloat)originX;

@end
