//
//  WYPosterPartView.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/26.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPosterConfigPart;

@interface WYPosterPartView : UIView

- (instancetype)initWithPosterPart:(WYPosterConfigPart *)part;

- (void)reloadPartConfig;

@end
