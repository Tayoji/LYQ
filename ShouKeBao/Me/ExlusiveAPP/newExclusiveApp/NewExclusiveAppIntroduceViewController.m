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


@end

@implementation NewExclusiveAppIntroduceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NewExclusiveAppIntroduceViewController"];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NewExclusiveAppIntroduceViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (fourSize) {
     self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+200*KHeight_Scale);
    }else if (fiveSize){
        self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+250*KHeight_Scale);
    }else if (sixSize){
        self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+290*KHeight_Scale);
    }else{
        self.ScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height+320*KHeight_Scale);
    }
    [self noOpenAxclusiveApp];
    
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

@end
