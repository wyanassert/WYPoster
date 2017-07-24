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
NSString *test1 = @"Looks to me like you can determine nWords however you like... it's just a variable used for the purposes of illustration here.";
NSString *test3 = @"la la Land";
NSString *test4 = @"iOS: set font size of UILabel Programmatically - Stack Overflow";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WYPosterConfigModel *config = [[WYPosterConfigModel alloc] init];
    config.ratio = 1;
    UIView *view = [WYPoster createViewUsingText:test4 withConfigModel:config];
    
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(100);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
