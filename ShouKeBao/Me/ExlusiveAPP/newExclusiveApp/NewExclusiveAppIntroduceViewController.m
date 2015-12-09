//
//  NewExclusiveAppIntroduceViewController.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/12/8.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewExclusiveAppIntroduceViewController.h"
#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/667.0f
#define View_width self.view.frame.size.width
#define View_height self.view.frame.size.height
@interface NewExclusiveAppIntroduceViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
- (IBAction)returnBtn:(id)sender;
- (IBAction)introduceBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *noOpenExclusive;


@end

@implementation NewExclusiveAppIntroduceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ScrollView.contentSize = CGSizeMake(0, View_height+200*KHeight_Scale);
    UIImageView *noOpenExclusive = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, View_width, View_height+200*KHeight_Scale)];
    noOpenExclusive.image = [UIImage imageNamed:@"noOpenExclusive"];
    self.noOpenExclusive = noOpenExclusive;
    [self.ScrollView addSubview:self.noOpenExclusive];
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.naVC popViewControllerAnimated:YES];
}

- (IBAction)introduceBtn:(id)sender {
}
@end
