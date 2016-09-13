//
//  ViewController.m
//  DNNerworking
//
//  Created by mainone on 16/9/12.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import "ViewController.h"
#import "DNNetwoking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [DNNetwoking Get:@"wap/index.php?ctl=article_cate&act=api_app_getarticle_cate&num=1&p=7" parameters:nil responseCache:^(id responseObject) {
        
    } success:^(id responseObject) {

    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
