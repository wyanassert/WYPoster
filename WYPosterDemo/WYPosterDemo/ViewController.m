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

NSString *test0 = @"deerjakbcx";
NSString *test1 = @"a bb ccc ddd eeee";
NSString *test2 = @"Looks to me like you can determine nWords however you like... it's just a variable used for the purposes of illustration here.";
NSString *test3 = @"la la Land";
NSString *test4 = @"iOS: set font size of UILabel Programmatically - Stack Overflow";
NSString *test5 = @"DOUBLE TAP TO EDIT TEXT!!!";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WYPosterConfigModel *config = [[WYPosterConfigModel alloc] init];
    config.ratio = 1;
    config.preferWidth = 300;
    UIView *view = [WYPoster createViewUsingText:test5 withConfigModel:config];
    
    [self.view addSubview:view];
    view.center = self.view.center;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
