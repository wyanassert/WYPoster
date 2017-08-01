//
//  ViewController.m
//  WYPoster
//
//  Created by wyan assert on 2017/7/21.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "ViewController.h"
#import "WYPoster.h"
#import "WYPosterConfigModel.h"
#import "Masonry.h"
#import "INTUAnimationEngine.h"

@interface ViewController ()

@property (nonatomic, strong) WYPosterView *posterView;
@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, assign) WYPreferLocalMultiLine         perferMultiLine;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.index = 1;
    self.perferMultiLine = WYPreferLocalMultiLineNone;
    [self actTo:self.index];
    
    {
        UIButton *btn = [UIButton new];
        [btn setFrame:CGRectMake(20, 20, 50, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"Last" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lastShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    {
        UIButton *btn = [UIButton new];
        [btn setFrame:CGRectMake(70, 20, 50, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"Next" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    {
        UIButton *btn = [UIButton new];
        [btn setFrame:CGRectMake(140, 20, 50, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"in" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(scaleShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    {
        UIButton *btn = [UIButton new];
        [btn setFrame:CGRectMake(190, 20, 50, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"out" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(scaleShow2) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    {
        UIButton *btn = [UIButton new];
        [btn setFrame:CGRectMake(250, 20, 60, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"refresh" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lastShow {
    self.index --;
    if(self.index < 0) {
        self.index = [self getArray].count - 1;
    }
    [self actTo:self.index];
}

- (void)nextShow {
    self.index ++;
    if(self.index >= [self getArray].count) {
        self.index = 0;
    }
    [self actTo:self.index];
}

- (void)scaleShow {
    [INTUAnimationEngine animateWithDuration:3 delay:0 animations:^(CGFloat percentage) {
        [self.posterView scaleTo:(1 - 0.7 * percentage)];
    } completion:^(BOOL finished) {
        [self.posterView scaleTo:1];
    }];
}

- (void)scaleShow2 {
    [INTUAnimationEngine animateWithDuration:3 delay:0 animations:^(CGFloat percentage) {
        [self.posterView scaleTo:(1 + percentage * 3)];
    } completion:^(BOOL finished) {
        [self.posterView scaleTo:1];
    }];
}

- (void)refresh {
    [self actTo:self.index];
}

- (void)actTo:(NSUInteger)index {
    WYPosterConfigModel *config = [[WYPosterConfigModel alloc] init];
    config.ratio = 1;
    config.preferWidth = 300;
//    config.localMultiLine = WYPreferLocalMultiLineNotLineTail | WYPreferLocalMultiLineNotFirstLine | WYPreferLocalMultiLineNotLineHead;
    config.localMultiLine = WYPreferLocalMultiLineNormal;
//    config.embedImageType = WYEmbedImageTypeLeftRight | WYEmbedImageTypeTopBottom;
//    config.sameWidth = YES;
    config.alignment = WYAlignmentCenter;
    if (self.posterView.superview) {
        [self.posterView removeFromSuperview];
    }
    self.posterView = [WYPoster createViewUsingText:[self getArray][index] withConfigModel:config];
    
    [self.view addSubview:self.posterView];
    self.posterView.center = self.view.center;
}

- (NSArray<NSString *> *)getArray {
    return @[
             @"deerjakbcx",
             @"a bb ccc ddd eeee",
             @"Looks to me like you can determine nWords however you like... it's just a variable used for the purposes of illustration here.",
             @"la la Land",
             @"iOS: set font size of UILabel Programmatically - Stack Overflow",
             @"DOUBLE TAP TO EDIT TEXT!!!",
             @"Objective-C is a general-purpose, object-oriented programming language that adds Smalltalk-style messaging to the C programming language. It was the main programming language used by Apple for the OS X and iOS operating systems, and their respective application programming interfaces (APIs) Cocoa and Cocoa Touch prior to the introduction of Swift.",
             @"AAAAAAjjj ggfj CCCCCCCCCCCC",
             @"The person who associated a work with this deed has dedicated the work to the public domain by waiving all of his or her rights to the work worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law.",
             ];
}


@end
