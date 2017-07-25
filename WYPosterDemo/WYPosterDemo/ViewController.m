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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WYPosterConfigModel *config = [[WYPosterConfigModel alloc] init];
    config.ratio = 1;
    config.preferWidth = 100;
    config.localMultiLine = WYPreferLocalMultiLineAny;
    WYPosterView *view = [WYPoster createViewUsingText:test1 withConfigModel:config];
    
    [self.view addSubview:view];
    view.center = self.view.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
