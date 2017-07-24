//
//  WYPosterConfigLine.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYPosterConfigUnit;

@interface WYPosterConfigLine : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<WYPosterConfigUnit *> *unitArray;
@property (nonatomic, assign, readonly) NSUInteger                  length;

- (void)addConfigUnit:(WYPosterConfigUnit *)unit;

@end
