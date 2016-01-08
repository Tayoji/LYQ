//
//  CustomerDetailAndOrderViewController.m
//  ShouKeBao
//
//  Created by 冯坤 on 15/8/7.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerDetailAndOrderViewController.h"
#import "CustomerOrderViewController.h"
#import "CustomerDetailViewController.h"
#import "ZhiVisitorDynamicController.h"
#import "CustomModel.h"
#import "Customers.h"
#import "EditCustomerDetailViewController.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "ChatViewController.h"

@interface CustomerDetailAndOrderViewController ()
@property (nonatomic, weak) UISegmentedControl *segmentControl;
@property (nonatomic, strong)CustomerOrderViewController * orderVC;
@property (nonatomic, strong)CustomerDetailViewController * detailVC;
@property (nonatomic, strong)ZhiVisitorDynamicController *customerDynamicVC;
@property (nonatomic, strong)UIButton *button;
@end

@implementation CustomerDetailAndOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavSegementView];
    [self customerRightBarItem];
    [self setNavBack];
    self.button.hidden = NO;
    [self addGest];
    [self.view addSubview:self.detailVC.view];
    
}
- (void)addGest{
    UISwipeGestureRecognizer *recognizer = recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleScreen:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:recognizer];
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleScreen:(UISwipeGestureRecognizer *)sender{
        [self back];
}
- (void)setNavSegementView{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"客户资料",@"订单详情", @"客人动态",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    [segment addTarget:self action:@selector(sex:)forControlEvents:UIControlEventValueChanged];
    [segment setTintColor:[UIColor whiteColor]];
    segment.frame = CGRectMake(0, 0, 200, 28);
    [segment setSelected:YES];
    [segment setSelectedSegmentIndex:0];
    [titleView addSubview:segment];
    self.segmentControl = segment;
    self.navigationItem.titleView = titleView;

}
- (void)setNavBack{
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,15)];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-1, -5, 0, 20);
    [leftBtn setImage:[UIImage imageNamed:@"fanhuian"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sex:(UISegmentedControl *)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    self.segmentControl.selectedSegmentIndex = control.selectedSegmentIndex;
    NSLog(@"..%ld", self.segmentControl.selectedSegmentIndex);
    if (control.selectedSegmentIndex == 0) {
        self.button.hidden = NO;
        [self.button setTitle:@"保存" forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateNormal];
        [self.view addSubview:self.detailVC.view];
        if (self.orderVC || self.customerDynamicVC) {
            [self.orderVC.view removeFromSuperview];
            [self.customerDynamicVC.view removeFromSuperview];
        }
        NSLog(@"客户资料" );
    }else if (control.selectedSegmentIndex == 1){
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"CustomerOrderDetailClick" attributes:dict];

        self.button.hidden = YES;
        [self.view addSubview:self.orderVC.view];
        if (self.detailVC || self.customerDynamicVC) {
            [self.detailVC.view removeFromSuperview];
            [self.customerDynamicVC.view removeFromSuperview];
        }
        NSLog(@"订单详情" );
    }else if (control.selectedSegmentIndex == 2){
        self.button.hidden = NO;
        [self.view addSubview:self.customerDynamicVC.view];
        [self.button setImage:[UIImage imageNamed:@"grayxiaoxi"] forState:UIControlStateNormal];
        [self.button setTitle:@"" forState:UIControlStateNormal];
        if (self.detailVC || self.orderVC) {
            [self.detailVC.view removeFromSuperview];
            [self.orderVC.view removeFromSuperview];
            
        }
    }
}
-(CustomerOrderViewController *)orderVC{

    if (!_orderVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        _orderVC = [sb instantiateViewControllerWithIdentifier:@"CustomerOrderID"];
        _orderVC.customerId = self.customerID;
        _orderVC.mainNav = self.navigationController;
    }
    return _orderVC;
}
-(CustomerDetailViewController *)detailVC{

    if (!_detailVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
        _detailVC = [sb instantiateViewControllerWithIdentifier:@"customerDetail"];
        _detailVC.Nav = self.navigationController;
        _detailVC.customerId = self.customerID;
        NSLog(@"%@", self.appUserID);
        _detailVC.AppSkbUserID = self.appUserID;
    }
    return _detailVC;
}

- (ZhiVisitorDynamicController *)customerDynamicVC{
    if (!_customerDynamicVC) {
        ZhiVisitorDynamicController *customerDynamicVC = [[ZhiVisitorDynamicController alloc]init];
        NSLog(@"%@", self.appUserID);
        customerDynamicVC.AppSkbUserId =self.appUserID;
        customerDynamicVC.visitorDynamicFromType = VisitorDynamicTypeFromCustom;
        _customerDynamicVC.view.backgroundColor = [UIColor yellowColor];
        _customerDynamicVC = customerDynamicVC;
    }
    return _customerDynamicVC;
}
-(void)customerRightBarItem{
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0,0,40,30);
    [self.button setTitle:@"保存" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.button addTarget:self action:@selector(saveCustomerDetail:)forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.button];
    
    self.navigationItem.rightBarButtonItem= barItem;
}


//-(void)EditCustomerDetail{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
//    
//    EditCustomerDetailViewController *edit = [sb instantiateViewControllerWithIdentifier:@"EditCustomer"];
//    edit.ID = _detailVC.customerId;
//    NSLog(@"%@", _detailVC.customerId);
//    edit.QQStr = self.detailVC.QQ.text;
//    edit.wechatStr = self.detailVC.weChat.text;
//    edit.noteStr = self.detailVC.note.text;
//    edit.teleStr = self.detailVC.tele.text;
//    edit.nameStr = self.detailVC.customerNameLa.text;
//    edit.delegate = self.detailVC;
//    //    添加的内容
//    edit.personCardIDStr = self.detailVC.userMessageID.text;
//    edit.birthdateStr = self.detailVC.bornDay.text;
//    edit.nationalityStr = self.detailVC.countryID.text;
//    edit.nationStr = self.detailVC.nationalID.text;
//    edit.passportDataStr = self.detailVC.pasportStartDay.text;
//    edit.passportAddressStr = self.detailVC.pasportAddress.text;
//    edit.passportValidityStr = self.detailVC.pasportInUseDay.text;
//    edit.addressStr = self.detailVC.livingAddress.text;
//    edit.passportStr = self.detailVC.passPortId.text;
//    [self.navigationController pushViewController:edit animated:YES];
//}

- (void)saveCustomerDetail:(NSString *)seg{
    
    if ( self.segmentControl.selectedSegmentIndex==0) {
  
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"保存中...";
    [hudView show:YES];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.detailVC.customerNameLa.text forKey:@"Name"];
        [dic setObject:self.detailVC.tele.text forKey:@"Mobile"];
        [dic setObject:self.detailVC.weChat.text forKey:@"WeiXinCode"];
        [dic setObject:self.detailVC.QQ.text forKey:@"QQCode"];
        [dic setObject:self.detailVC.note.text forKey:@"Remark"];
        [dic setObject:_detailVC.customerId forKey:@"ID"];
        
        //        新添加的内容
        [dic setObject:self.detailVC.userMessageID.text forKey:@"CardNum"];
        [dic setObject:self.detailVC.bornDay.text forKey:@"BirthDay"];
        [dic setObject:self.detailVC.countryID.text forKey:@"Nationality"];
        [dic setObject:self.detailVC.nationalID.text forKey:@"Country"];
        [dic setObject:self.detailVC.pasportStartDay.text forKey:@"ValidStartDate"];
        [dic setObject:self.detailVC.pasportAddress.text forKey:@"ValidAddress"];
        [dic setObject:self.detailVC.pasportInUseDay.text forKey:@"ValidEndDate"];
        [dic setObject:self.detailVC.livingAddress.text forKey:@"Address"];
        [dic setObject:self.detailVC.passPortId.text forKey:@"PassportNum"];
    
        NSMutableDictionary *secondDic = [NSMutableDictionary dictionary];
        [secondDic setObject:dic forKey:@"Customer"];
        
        [IWHttpTool WMpostWithURL:@"Customer/EditCustomer" params:secondDic success:^(id json) {
            NSLog(@"---- b编辑单个客户成功 %@------",json);
            if ( [[NSString stringWithFormat:@"%@",json[@"IsSuccess"]]isEqualToString:@"0"]) {
                UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:json[@"ErrorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aler show];
            }
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            hudView.labelText = @"保存成功...";
            [center postNotificationName:@"refreashCustom" object:@"开心" userInfo:nil];
            
            [hudView hide:YES afterDelay:0.4];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            NSLog(@"-----创建单个客户失败 %@-----",error);
        }];
    }else if (self.segmentControl.selectedSegmentIndex == 2){
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:self.AppSkbUserId conversationType:eConversationTypeChat];
        chatController.title = self.name;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}
@end
