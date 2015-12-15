//
//  NewExclusiveAppIntroduceViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/12/8.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewExclusiveAppIntroduceViewController.h"
#import "noOpenExclusiveAppView.h"
#import "WhatIsExclusiveViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/667.0f
#define View_width self.view.frame.size.width
#define View_height self.view.frame.size.height

#define fourSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)
@interface NewExclusiveAppIntroduceViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
- (IBAction)returnBtn:(id)sender;
- (IBAction)introduceBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *noOpenExclusive;
@property (weak, nonatomic) IBOutlet UIView *backgroundShareView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation NewExclusiveAppIntroduceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (fourSize) {
     self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+170*KHeight_Scale);
    }else if (fiveSize){
        self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+220*KHeight_Scale);
    }else if (sixSize){
        self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+260*KHeight_Scale);
    }else{
        self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+285*KHeight_Scale);
    }
    [self noOpenAxclusiveApp];
    
}

- (void)setView1:(UIView *)view1{
    _view1 = view1;
    view1.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    view1.layer.borderWidth = 1;
}

- (void)setView2:(UIView *)view2{
    _view2 = view2;
    view2.layer.borderColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1].CGColor;
    view2.layer.borderWidth = 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)noOpenAxclusiveApp{
    [noOpenExclusiveAppView backgroundShareView:self.backgroundShareView andUrl:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnBtn:(id)sender {
    [self.naVC popToRootViewControllerAnimated:YES];
    
}

- (IBAction)introduceBtn:(id)sender {
    WhatIsExclusiveViewController *WhatIsExclusiveVC = [[WhatIsExclusiveViewController alloc]init];
    WhatIsExclusiveVC.naV = self.naVC;
    [self.naVC pushViewController:WhatIsExclusiveVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NewExclusiveAppIntroduceViewController"];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NewExclusiveAppIntroduceViewController"];
}
@end
