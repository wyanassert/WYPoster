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
#import "WYPosterLayer.h"

@interface ViewController ()

@property (nonatomic, strong) WYPosterView  *posterView;
@property (nonatomic, strong) WYPosterLayer *posterLayer;
@property (nonatomic, assign) NSInteger     index;
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
        [btn setTitle:@"chCol" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(scaleShow) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    {
        UIButton *btn = [UIButton new];
        [btn setFrame:CGRectMake(190, 20, 50, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"" forState:UIControlStateNormal];
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
    [self.posterLayer setColor:@[[UIColor purpleColor]]];
}

- (void)scaleShow2 {
    
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
    config.embedImageType = WYEmbedImageTypeTop | WYEmbedImageTypeBottom | WYEmbedImageTypeRight | WYEmbedImageTypeLeft;
    config.sameWidth = YES;
    config.alignment = WYAlignmentCenter;
    config.maxMultiLineCountPerLine = 1;
    config.lineInterval = 10;
    config.fontArray = @[
                         [UIFont fontWithName:@"Arial-BoldItalicMT" size:13],
                         [UIFont fontWithName:@"Baskerville-Italic" size:12],
                         [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:14],
                         [UIFont fontWithName:@"SnellRoundhand-Bold" size:17],
//                         [UIFont fontWithName:@"Zapfino" size:10],
                         ];
    config.enableMultiFontInLine = YES;
    config.defaultColors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
    config.enableMultiColorInLine = YES;
    config.leftRightImageNames = @[@"h000", @"h001", @"h002", @"h003", @"h004", @"h005", @"h006", @"h007", @"h008", @"h009", @"h010", @"h011", @"h012", @"h013", @"h014", @"h015", @"h016", @"h017"];
    config.topBottomImageNames = @[@"v000", @"v001", @"v002", @"v003", @"v004", @"v005", @"v006", @"v007", @"v008", @"v009", @"v010", @"v011", @"v012", @"v013", @"v014", @"v015", @"v016", @"v017", @"v018", @"v019"];
    
    if (self.posterView.superview) {
        [self.posterView removeFromSuperview];
    }
//    self.posterView = [WYPoster createViewUsingText:[self getArray][index] withConfigModel:config];

//    [self.view addSubview:self.posterView];
//    self.posterView.frame = CGRectMake((self.view.frame.size.width - self.posterView.frame.size.width)/2, self.view.bounds.size.height - self.posterView.bounds.size.height, self.posterView.bounds.size.width, self.posterView.bounds.size.height);
    
    if(self.posterLayer.superlayer) {
        [self.posterLayer removeFromSuperlayer];
    }
    self.posterLayer = [WYPoster createLayerUsingText:[self getArray][index] withConfigModel:config];
    [self.view.layer addSublayer:self.posterLayer];
    [self.posterLayer setFrame:CGRectMake((self.view.bounds.size.width - self.posterLayer.frame.size.width)/2, 80, self.posterLayer.frame.size.width, self.posterLayer.frame.size.height)];
}

- (NSArray<NSString *> *)getArray {
    return @[
             @"deerjakbcx",
             @"a bb ccc ddd eEgG",
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
