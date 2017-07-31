//
//  WYPosterConfigPart.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/26.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WYPosterConfigLine;

@interface WYPosterConfigPart : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<WYPosterConfigLine*> *lineArray;
@property (nonatomic, assign, readonly) NSUInteger         baseCount;
@property (nonatomic, assign, readonly) CGFloat            width;
@property (nonatomic, assign, readonly) CGFloat            height;

@property (nonatomic, strong) NSArray<UIFont *>      *fontArray;
@property (nonatomic, assign) CGFloat                scale;

- (void)addConfigLine:(WYPosterConfigLine *)line;

- (void)keepSameWidth;

@end
