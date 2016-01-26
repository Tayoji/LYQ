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
#import "IWHttpTool.h"
#import "MBProgressHUD.h"
#import "EaseMob.h"
#import "ChatSendHelper.h"
#import "NewMessageCenterController.h"
#import "RuleWebViewController.h"
#import "APNSHelper.h"
#import "EMMessage.h"
#import "StrToDic.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface SetRedPacketController ()<UIScrollViewDelegate,UITextFieldDelegate>
//@property (nonatomic,strong) UIView *WarningView;
//@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSMutableArray *IDsdataArr;
@property (nonatomic, strong)EMMessage * tempMeesage;
@end

@implementation SetRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"抵用券红包";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavTest"] forBarMetrics:UIBarMetricsDefault];
    self.NumOfRedPLabel.text = [NSString stringWithFormat:@"%ld",self.NumOfPeopleArr.count];
    [self creatNavOfRight];
    NSLog(@"%@",self.NumOfPeopleArr);
    self.ExitCountryTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.InlandTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.RimTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.ScrollView.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
    self.SendRedPacketBtn.enabled = NO;
    self.SendRedPacketBtn.alpha = 0.5;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.RedPDescribeTextView resignFirstResponder];
    [self.ExitCountryTextField resignFirstResponder];
    [self.InlandTextField resignFirstResponder];
    [self.RimTextField resignFirstResponder];
}

-(void)creatNavOfRight{
    UIButton *myBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [myBtn setImage:[UIImage imageNamed:@"RedPacketHelp"] forState:UIControlStateNormal];
    myBtn.tag = 106;
    [myBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:myBtn];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)BtnClick:(UIButton *)button{
    
    [self.RedPDescribeTextView resignFirstResponder];
    [self.ExitCountryTextField resignFirstResponder];
    [self.InlandTextField resignFirstResponder];
    [self.RimTextField resignFirstResponder];
    
    if (button.tag == 106) {//问好
        NSLog(@"点击问号");
        RuleWebViewController *cont = [[RuleWebViewController alloc] init];
        cont.linkUrl = @"http://m.lvyouquan.cn/App/AppLuckMoneyProduceNote";
        cont.webTitle = @"红包生成说明";
        [self.navigationController pushViewController:cont animated:YES];
    }
//    else if(button.tag == 105){//叉号
//        [self removeWowView];
//    }else if(button.tag == 107){//取消
//        [self removeWowView];
//    }else if(button.tag == 108){//确定
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:@"1" forKey:@"SetRedPacketjumpMesGuide"];
//        
////        [self removeWowView];
//        [self computeMoney];
//        [self loadRedPacketRequest];
//    }
    
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@",textField.text);
     NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 4) { //如果输入框内容大于20则弹出警告
        textField.text = [toBeString substringToIndex:4];
        
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"=====%f",textField.text.floatValue);
    switch (textField.tag) {
        case 101:
            self.ExitCountryN = textField.text.floatValue;
            break;
        case 102:
            self.InlandN = textField.text.floatValue;
            break;
        case 103:
            self.RimN = textField.text.floatValue;
            break;
            
        default:
            break;
    }
    [self computeMoney];
    return YES;
}
//红包总价计算方法
-(void)computeMoney{
    CGFloat sum = self.ExitCountryN+self.InlandN+self.RimN;
    self.FinalMoney = sum*self.NumOfPeopleArr.count;
    self.FinalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.FinalMoney];
    if (self.FinalMoney !=  0) {
        self.SendRedPacketBtn.enabled = YES;
        self.SendRedPacketBtn.alpha = 1;
    }else{
        self.SendRedPacketBtn.enabled = NO;
        self.SendRedPacketBtn.alpha = 0.5;
    }
//    if (Num == 2) {
//        NSLog(@"===%f",self.FinalMoney);
//        [self.view.window addSubview:self.backGroundView];
//        [self.view.window addSubview:self.WarningView];
//    }
}
-(NSMutableArray *)NumOfPeopleArr{
    if (!_NumOfPeopleArr) {
        _NumOfPeopleArr = [[NSMutableArray alloc] init];
    }
    return _NumOfPeopleArr;
}
//自定义警告框
//-(UIView *)WarningView{
//    if (!_WarningView) {
//        _WarningView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenSize.height/3, kScreenSize.width-60, 180)];
//        _WarningView.layer.masksToBounds = YES;
//        _WarningView.layer.cornerRadius = 6.0;
//        _WarningView.backgroundColor = [UIColor whiteColor];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _WarningView.frame.size.width, _WarningView.frame.size.height/4)];
//        imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wow2RedPacket"]];
//        imageView.userInteractionEnabled = YES;
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_WarningView.frame.size.width-35, 10, 20, 20)];
//        [btn setBackgroundImage:[UIImage imageNamed:@"WowOfRedPacketCanal"] forState:UIControlStateNormal];
//        btn.tag = 105;
//        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [imageView addSubview:btn];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, _WarningView.frame.size.height/4, _WarningView.frame.size.width-60, 70)];
//        label.lineBreakMode = UILineBreakModeWordWrap;
//        label.numberOfLines = 0;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"红包一旦生成，红包内的价格不可修改，请确定您发放的金额正确";
//        label.font = [UIFont systemFontOfSize:18];
//        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(_WarningView.frame.size.width/2-120, _WarningView.frame.size.height/4+80, 100, 40)];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"WowOfRedPacketBtn"] forState:UIControlStateNormal];
//        [btn2 setTitle:@"取消" forState:UIControlStateNormal];
//        [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn2.tag = 107;
//        UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(_WarningView.frame.size.width/2+20, _WarningView.frame.size.height/4+80, 100, 40)];
//        [btn3 setBackgroundImage:[UIImage imageNamed:@"WowOfRedPacketBtn"] forState:UIControlStateNormal];
//        [btn3 setTitle:@"确定" forState:UIControlStateNormal];
//        [btn3 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [btn3 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn3.tag = 108;
//        [_WarningView addSubview:imageView];
//        [_WarningView addSubview:label];
//        [_WarningView addSubview:btn2];
//        [_WarningView addSubview:btn3];
//        
//    }
//    return _WarningView;
//}
//警告框背景蒙层
//-(UIView *)backGroundView{
//    if (!_backGroundView) {
//        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
//        _backGroundView.backgroundColor = [UIColor blackColor];
//        _backGroundView.alpha = 0.5;
//    }
//    return _backGroundView;
//}
-(void)loadRedPacketRequest{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"2" forKey:@"LuckMoneyType"];
    [dic setValue:self.RedPDescribeTextView.text forKey:@"Topic"];
    [dic setValue:[NSString stringWithFormat:@"%ld",self.NumOfPeopleArr.count] forKey:@"RedEnvelopeCount"];
    [dic setValue:[NSString stringWithFormat:@"%f",self.ExitCountryN] forKey:@"OutTotalPrice"];
    [dic setValue:[NSString stringWithFormat:@"%f",self.InlandN] forKey:@"InsideTotalPrice"];
    [dic setValue:[NSString stringWithFormat:@"%f",self.RimN] forKey:@"NearbyTotalPrice"];
    [dic setValue:self.NumOfPeopleArr forKey:@"AppSkbUserList"];
    NSLog(@"%@",dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [IWHttpTool WMpostWithURL:@"/Customer/HairRedEnvelope" params:dic success:^(id json) {
        NSLog(@"----------红包返回列表%@---------",json);
        self.IDsdataArr = json[@"AppRedEnvelopeIdList"];//服务器返回的发红包数据
        [self performSelectorInBackground:@selector(sendRedPacket) withObject:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    }];
}//AppRedEnvelopeId
//AppSkbUserId
-(NSMutableArray  *)IDsdataArr{
    if (!_IDsdataArr) {
        _IDsdataArr = [[NSMutableArray alloc] init];
    }
    return _IDsdataArr;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jianbian"] forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --此处发红包
- (void)sendRedPacket{
    
    for (NSDictionary * postDic in self.IDsdataArr) {
        NSString * AppRedEnvelopeId = postDic[@"AppRedEnvelopeId"];
        NSString * AppRedEnvelopeNoId = postDic[@"AppRedEnvelopeNoId"];
        NSString * AppSkbUserId = postDic[@"AppSkbUserId"];
        NSDictionary * sendDic = @{@"AppRedEnvelopeId":AppRedEnvelopeId,@"AppRedEnvelopeNoId": AppRedEnvelopeNoId};
        NSString * jsonStr = [StrToDic jsonStringWithDicL:sendDic];
        NSDictionary *ext = @{@"MsgType":@"4",@"MsgValue":jsonStr};
        NSLog(@"%@", jsonStr);
       self.tempMeesage = [ChatSendHelper sendTextMessageWithString:@"[红包]"
                                                                toUsername:AppSkbUserId
                                                               messageType:eMessageTypeChat
                                                         requireEncryption:NO
                                                                       ext:ext];
    }
    if (self.sendRedPacketType == sendRedPacketTypeChatVC) {
        [self performSelectorOnMainThread:@selector(backToChat) withObject:nil waitUntilDone:YES];
        return;
    }
    if (self.IDsdataArr.count == 1) {
        [APNSHelper defaultAPNSHelper].isJumpChat = YES;
        [APNSHelper defaultAPNSHelper].chatName = self.IDsdataArr[0][@"AppSkbUserId"];
    }else if(self.IDsdataArr.count > 1){
        [APNSHelper defaultAPNSHelper].isJumpChatList = YES;
    }
    [self performSelectorOnMainThread:@selector(pushInMainTheard) withObject:nil waitUntilDone:YES];
}

- (void)backToChat{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSendRedPacket:)]) {
        [self.delegate didSendRedPacket:self.tempMeesage];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)pushInMainTheard{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.navigationController.tabBarController.selectedViewController = [self.navigationController.tabBarController.viewControllers objectAtIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"SetRedPacketjumpMesGuide"];
        
//        [self removeWowView];
        [self computeMoney];
        [self loadRedPacketRequest];
    }
    NSLog(@"clickButtonAtIndex:%ld",buttonIndex);
}
- (IBAction)GrantRPBtn:(UIButton *)sender {
    [self.ExitCountryTextField endEditing:YES];
    [self.InlandTextField endEditing:YES];
    [self.RimTextField endEditing:YES];
    [self computeMoney];

    [[[UIAlertView alloc]initWithTitle:nil message:@"红包一旦生成，红包内的价格不可修改，请确定您发放的金额正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", @"确定",nil]show];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self loadRedPacketRequest];
//    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:model.AppSkbUserId conversationType:eConversationTypeChat];
//    chatController.title = model.Name;
//    [self.navigationController pushViewController:chatController animated:YES];
}
@end
