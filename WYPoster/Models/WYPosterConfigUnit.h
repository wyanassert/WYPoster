//
//  WYPosterConfigUnit.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/24.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYPosterConfigUnitType) {
    WYPosterConfigUnitTypeNormal = 0,
    WYPosterConfigUnitTypeMultiLine,
    WYPosterConfigUnitTypeImage
};


@class WYPosterConfigLine;

@interface WYPosterConfigUnit : NSObject

@property (nonatomic, assign, readonly) WYPosterConfigUnitType unitType;
@property (nonatomic, assign, readonly) NSUInteger             length;
@property (nonatomic, strong, readonly) NSString               *word;
@property (nonatomic, strong, readonly) UIFont                 *font;

- (instancetype)initWithWord:(NSString *)word font:(UIFont *)font;

@end
