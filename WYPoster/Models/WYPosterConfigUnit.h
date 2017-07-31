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

typedef NS_ENUM(NSUInteger, WYPosterConfigUintImageOritention) {
    WYPosterConfigUintImageTop,
    WYPosterConfigUintImageLeft,
    WYPosterConfigUintImageRight,
    WYPosterConfigUintImageBottom
};



@class WYPosterConfigLine;
@class WYPosterConfigPart;

@interface WYPosterConfigUnit : NSObject

@property (nonatomic, assign, readonly) WYPosterConfigUnitType unitType;
@property (nonatomic, assign, readonly) NSUInteger             baseCount;
@property (nonatomic, assign, readonly) NSUInteger             length;
@property (nonatomic, assign, readonly) CGFloat                width;
@property (nonatomic, assign, readonly) CGFloat                height;
@property (nonatomic, assign,         ) CGFloat                scale;

@property (nonatomic, strong, readonly) NSString               *word;
@property (nonatomic, strong, readonly) UIFont                 *font;

@property (nonatomic, strong, readonly) NSArray<NSArray<NSString *> *> *multiWords;
@property (nonatomic, strong, readonly) NSArray<UIFont *>              *multiFont;
@property (nonatomic, strong, readonly) WYPosterConfigPart             *configPart;

@property (nonatomic, strong, readonly) UIImage                        *image;
@property (nonatomic, assign, readwrite) UIImageOrientation            oritention;

- (instancetype)initWithWord:(NSString *)word font:(UIFont *)font;
- (instancetype)initWithWords:(NSArray<NSArray<NSString *> *> *)multiWords fonts:(NSArray<UIFont *> *)multiFont;
- (instancetype)initWithImage:(UIImage *)image;

@end
