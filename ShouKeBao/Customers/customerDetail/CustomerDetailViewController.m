//
//  CustomerDetailViewController.m
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "EditCustomerDetailViewController.h"
#import "CustomerOrdersUIViewController.h"
#import "remondViewController.h"
#import "IWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "CustomModel.h"
#import "MobClick.h"
#import "attachmentViewController.h"
#import "AttachmentCollectionView.h"
#import "CustomerOrderViewController.h"
#import "IWHttpTool.h"  
#import "CustomModel.h"
#import "UIImageView+WebCache.h"
#define Height [UIScreen mainScreen].bounds.size.height/480
#define Width [UIScreen mainScreen].bounds.size.width/320
@interface CustomerDetailViewController ()<UITextFieldDelegate,notifiToRefereshCustomerDetailInfo,UIActionSheetDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *SetRemindBtnOutlet;
@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation CustomerDetailViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)setCustomerNameLa:(UITextField *)customerNameLa{
    _customerNameLa = customerNameLa;
//     [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详情";
    self.tableView.delegate = self;
    
    [self loadCustomerDetailData];
    if (self.note.text == nil) {
        self.note.text = @"备注信息";
    }
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,15,20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.SetRemindBtnOutlet.imageEdgeInsets = UIEdgeInsetsMake(0, 32, 0, 0);
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CustomerDetailViewController"];
    // [self.segmentControl setSelectedSegmentIndex:0];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CustomerDetailViewController"];
}

#pragma -mark 编辑用户资料后通知更新
- (void)refreshCustomerInfoWithName:(NSString *)name andQQ:(NSString *)qq andWeChat:(NSString *)weChat andPhone:(NSString *)phone andCardID:(NSString *)cardID andBirthDate:(NSString *)birthdate andNationablity:(NSString *)nationablity andNation:(NSString *)nation andPassportStart:(NSString *)passPortStart andPassPortAddress:(NSString *)passPortAddress andPassPortEnd:(NSString *)passPortEnd andAddress:(NSString *)address andPassport:(NSString *)passPort andNote:(NSString *)note nickName:(NSString *)nickName{
    self.QQ.text = qq;
    self.weChat.text = weChat;
    self.tele.text = phone;
    self.note.text = note;
    self.customerNameLa.text = name;
    //   新添加
    self.userMessageID.text = cardID;
    self.bornDay.text = birthdate;
    self.countryID.text = nationablity;
    self.nationalID.text = nation;
    self.pasportStartDay.text = passPortStart;
    self.pasportAddress.text = passPortAddress;
    self.pasportInUseDay.text = passPortEnd;
    self.passPortId.text = passPort;
    self.livingAddress.text = address;
    self.nickNameF.text = nickName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)remond:(id)sender {
    remondViewController *remond = [[remondViewController alloc] init];
    remond.ID = [self.dataArr[0]ID];
    remond.customModel = self.dataArr[0];
    [self.Nav pushViewController:remond animated:YES];
}

- (IBAction)deleteCustomer:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
     [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
        hudView.labelText = @"删除中...";
        [hudView show:YES];
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[self.dataArr[0]ID] forKey:@"CustomerID"];
        [IWHttpTool WMpostWithURL:@"/Customer/DeleteCustomer" params:dic success:^(id json) {
            NSLog(@"删除客户信息成功%@",json);

            [self.delegate deleteCustomerWith:nil];
            hudView.labelText = @"删除成功...";
            [hudView hide:YES afterDelay:0.4];
            
        } failure:^(NSError *error) {
            NSLog(@"删除客户请求失败%@",error);
        }];
        [self.Nav popViewControllerAnimated:YES];
    }
    if (buttonIndex == 1) {
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString * telStr = [NSString stringWithFormat:@"tel://%@", self.tele.text];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:telStr]];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0){
    
    }else{
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView * subView in cell.contentView.subviews) {
        if ([subView isKindOfClass:[UITextField  class]]) {
            [subView becomeFirstResponder];
        }
    }
    
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//            {
//                if (self.tele.text.length > 6) {
//                    [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@", self.tele.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
//                }else{
//                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
//                }
//            }
//                break;
//            case 1:
//            {
//                if ([self.weChat.text isEqualToString:@""]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信号码为空！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }else if(![self.weChat.text isEqualToString:@""] && ![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]){
//                    UIAlertView*ale=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机微信，请安装手机微信后重试，或用PC进行操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [ale show];
//                }else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]] && ![self.weChat.text isEqualToString:@""]){
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"]];
//                }
//
////                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]] && ![self.weChat.text isEqualToString:@""]) {
////                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"]];
////                }
//            }
//                break;
//            case 2:
//            {
//                if ([self.QQ.text isEqualToString:@""]) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"QQ号码为空!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }else{
//                    if (![self joinGroup:nil key:nil]) {
//                        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        [ale show];
//                    }
//                }
//
////                
////                if (![self joinGroup:nil key:nil] && ![self.QQ.text isEqualToString:@""]) {
////                    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
////                    [ale show];
////                }
//            }
//                break;
//
//            default:
//                break;
//        }
//    }

}


- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=6481427ed9be2a6b6df78d95f2abf8a0ebaed07baefe3a2bea8bd847cb9d84ed&card_type=group&source=external"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        NSString *qqStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQ.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqStr]];
        return YES;
    }else
        return NO;
}

- (BOOL)joinWet:(NSString *)group key:(NSString *)key{
    return YES;
}

- (IBAction)clickButtonCaling:(id)sender {
    if (self.tele.text.length > 6) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@", self.tele.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    }
}

- (IBAction)attachmentAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Customer" bundle:nil];
    AttachmentCollectionView *AVC = [sb instantiateViewControllerWithIdentifier:@"AttachmentCollectionView"];
    AVC.customerId = [self.dataArr[0]ID];
    AVC.fromType = fromTypeCustom;
    [self.Nav pushViewController:AVC animated:YES];
    
}

- (void)loadCustomerDetailData{
    
    MBProgressHUD *hudView = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    hudView.labelText = @"加载中...";
    [hudView show:YES];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *appSkbUserID = self.AppSkbUserID;
    [dic setObject:self.customerId forKey:@"CustomerID"];
    [dic setObject:appSkbUserID forKey:@"AppSkbUserID"];
     NSLog(@"%@",dic);
    [IWHttpTool WMpostWithURL:@"/Customer/GetCustomer" params:dic success:^(id json){
        NSLog(@"------管客户详情json is %@",json);
        if ([json[@"IsSuccess"]isEqualToString:@"1"]) {
            NSDictionary *dic = json[@"Customer"];
            self.customerId = dic[@"ID"];
            CustomModel *customerDetail = [CustomModel modalWithDict:dic];
            [self.dataArr addObject:customerDetail];
            [self setSubViews];
        }
        hudView.labelText = @"加载成功...";
        [hudView hide:YES afterDelay:0.4];
    } failure:^(NSError *error) {
        NSLog(@"-------管客户详情请求失败 error is %@",error);
    }];
}

- (void)setCustomerIconActin{
    
    UIButton *customerIm = [UIButton buttonWithType:UIButtonTypeCustom];
    customerIm.frame = CGRectMake(230*Width, 30*Height, 60, 60);
    [self.tableView addSubview:customerIm];
    self.customerIconB = customerIm;
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView *nameima = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    
    self.customerIconB.layer.masksToBounds = YES;
    self.customerIconB.layer.cornerRadius = 30;
    [self.customerIconB.layer setBorderWidth:2.0];
    [self.customerIconB.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    
    if ([[self.dataArr[0]HeadUrl] isEqualToString:@""]|| [self.dataArr[0]HeadUrl].length == 0) {
        [self.customerIconB addSubview:nameLable];
        
        self.customerIconB.backgroundColor = [UIColor colorWithRed:0/225.0f green:173.0/225.0f blue:239.0/225.0f alpha:1];
         NSString *text = [[NSString stringWithFormat:@"%@", [self.dataArr[0]Name]] substringToIndex:1];
        NSMutableAttributedString *aa = [[NSMutableAttributedString alloc] initWithString:text];
        [aa addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(0, 1)];
        [aa addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
        [self.customerIconB setAttributedTitle:aa forState:UIControlStateNormal];

    }else{
        [self.customerIconB addSubview:nameima];
        [nameima sd_setImageWithURL:[NSURL URLWithString:[self.dataArr[0]HeadUrl]]];
    }
    
    

}
-(void)setSubViews{
    [self setCustomerIconActin];
    self.QQ.text = [self.dataArr[0]QQCode];
    self.weChat.text =  [self.dataArr[0]WeiXinCode]; /*self.weChatStr;*/
    self.tele.text = [self.dataArr[0]Mobile];/*self.teleStr;*/
    self.note.text = [self.dataArr[0]Remark];/*self.noteStr;*/
    self.customerNameLa.text = [self.dataArr[0]Name];/*self.userNameStr;*/
    self.nickNameF.text = [self.dataArr[0]NickName];
    self.passPortId.text = [self.dataArr[0]PassportNum];
    self.userMessageID.text = [self.dataArr[0]CardNum];
    self.bornDay.text = [self.dataArr[0]BirthDay];
    self.countryID.text = [self.dataArr[0]Country];
    self.nationalID.text = [self.dataArr[0]Nationality];
    self.pasportStartDay.text = [self.dataArr[0]ValidStartDate];
    self.pasportAddress.text  = [self.dataArr[0]ValidAddress];
    self.pasportInUseDay.text = [self.dataArr[0]ValidEndDate];
    self.livingAddress.text = [self.dataArr[0]Address];
}

- (IBAction)callPhone:(UIButton *)sender {
    if (self.tele.text.length > 6) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否要拨打电话%@", self.tele.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码不正确" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
    }
}

- (IBAction)jumpWeChat:(UIButton *)sender {
    if ([self.weChat.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信号码为空！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else if(![self.weChat.text isEqualToString:@""] && ![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        UIAlertView*ale=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机微信，请安装手机微信后重试，或用PC进行操作。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [ale show];
    }else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]] && ![self.weChat.text isEqualToString:@""]){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"weixin://"]];
    }

}

- (IBAction)jumpQQ:(UIButton *)sender {
    if ([self.QQ.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"QQ号码为空!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        if (![self joinGroup:nil key:nil]) {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有安装手机QQ，请安装手机QQ后重试，或用PC进行操作。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [ale show];
        }
    }
}
@end
