//
//  WYPosterView.h
//  WYPoster
//
//  Created by wyan assert on 2017/7/21.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPosterConfigModel;

@interface WYPosterView : UIView

@property (nonatomic, assign) CGSize         preferSize;

- (instancetype)initWithConfig:(WYPosterConfigModel *)configModel;

@end
