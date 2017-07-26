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

NSString *test0 = @"deerjakbcx";
NSString *test1 = @"a bb ccc ddd eeee";
NSString *test2 = @"Looks to me like you can determine nWords however you like... it's just a variable used for the purposes of illustration here.";
NSString *test3 = @"la la Land";
NSString *test4 = @"iOS: set font size of UILabel Programmatically - Stack Overflow";
NSString *test5 = @"DOUBLE TAP TO EDIT TEXT!!!";
NSString *test6 = @"Objective-C is a general-purpose, object-oriented programming language that adds Smalltalk-style messaging to the C programming language. It was the main programming language used by Apple for the OS X and iOS operating systems, and their respective application programming interfaces (APIs) Cocoa and Cocoa Touch prior to the introduction of Swift.";
NSString *test7 = @"AAAAAAjjj ggfj CCCCCCCCCCCC";

@interface ViewController ()

@property (nonatomic, strong) WYPosterView *posterView;
@property (nonatomic, assign) NSInteger         index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.index = 0;
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
        [btn setFrame:CGRectMake(120, 20, 50, 50)];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setTitle:@"Next" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextShow) forControlEvents:UIControlEventTouchUpInside];
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

- (void)actTo:(NSUInteger)index {
    WYPosterConfigModel *config = [[WYPosterConfigModel alloc] init];
    config.ratio = 1;
    config.preferWidth = 100;
    //    config.localMultiLine = WYPreferLocalMultiLineAny;
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
             ];
}


@end
