//
//  SetRedPacketController.m
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SetRedPacketController.h"
#import "ChatViewController.h"
#import "CustomModel.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface SetRedPacketController ()<UIScrollViewDelegate,UITextViewDelegate>

@end

@implementation SetRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"指定送红包";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
    [self creatNavOfRight];
    self.ExitCountryTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.InlandTextView.keyboardType = UIKeyboardTypeNumberPad;
    self.RimtextView.keyboardType = UIKeyboardTypeNumberPad;
    self.ScrollView.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.RedPDescribeTextView resignFirstResponder];
    [self.ExitCountryTextView resignFirstResponder];
    [self.InlandTextView resignFirstResponder];
    [self.RimtextView resignFirstResponder];
}

-(void)creatNavOfRight{
    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [myBtn setImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:myBtn];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)BtnClick:(UIButton *)button{
    NSLog(@"点击问号");
    
}
#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    switch (textView.tag) {
        case 101:
            self.ExitCountryTextView.text = @"";
            break;
        case 102:
            self.InlandTextView.text = @"";
            break;
        case 103:
            self.RimtextView.text = @"";
            break;
        case 104:
            
            break;
            
        default:
            break;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"----%@",textView.text);
    if ([textView.text isEqualToString:@""]) {
        if (textView.tag == 101 || textView.tag == 102 || textView.tag == 103) {
            textView.text = @"填写金额";
        }
    }
    NSLog(@"%@",textView.text);
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jianbian"] forBarMetrics:UIBarMetricsDefault];
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

- (IBAction)GrantRPBtn:(UIButton *)sender {
    CustomModel *model = nil;
//    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:model.AppSkbUserId conversationType:eConversationTypeChat];
//    chatController.title = model.Name;
//    [self.navigationController pushViewController:chatController animated:YES];
}
@end
