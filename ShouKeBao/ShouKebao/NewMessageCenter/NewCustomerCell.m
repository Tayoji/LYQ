//
//  NewCustomerCell.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import "NewCustomerCell.h"
#import "CustomDynamicModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+FKTools.h"
#import "ChatViewController.h"
#import "VisitorDynamicProductView.h"
#import "NSString+FKTools.h"
#import "ProductModal.h"
#import "CustomerDetailAndOrderViewController.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "ProduceDetailViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface NewCustomerCell ()<UIWebViewDelegate>
- (IBAction)MessageBtnClick:(UIButton *)sender;

@end

@implementation NewCustomerCell
- (void)awakeFromNib {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openIM)];
    [self.TitleImage addGestureRecognizer:tap];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCustormDet)];
    self.MessageLab.userInteractionEnabled = YES;
    [self.MessageLab addGestureRecognizer:tap2];
    VisitorDynamicProductView * productView = [[[NSBundle mainBundle] loadNibNamed:@"VisitorDynamicProductView" owner:nil options:nil] lastObject];
    self.ProductView = productView;
    self.ProductView.hidden = YES;
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openProduct)];

    [self.ProductView addGestureRecognizer:tap3];
    [self addSubview:self.ProductView];
    
    self.nameLabel.backgroundColor = [UIColor colorWithRed:61/255.0 green:156/255.0 blue:177/255.0 alpha:1];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.layer.cornerRadius = 20;
    self.nameLabel.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:18];
    
}
-(void)layoutSubviews{
    CGFloat Messagelabh = [self.model.DynamicTitleV2 heigthWithsysFont:14 withWidth:self.MessageLab.frame.size.width];
    CGRect Messagelabf = CGRectMake(self.MessageLab.frame.origin.x, self.MessageLab.frame.origin.y, self.MessageLab.frame.size.width, Messagelabh);
    self.MessageLab.frame = Messagelabf;
    
    if ([self.model.DynamicType intValue] == 1 || [self.model.DynamicType intValue] == 2||[self.model.DynamicType intValue] == 3||[self.model.DynamicType intValue] == 9||[self.model.DynamicType intValue] == 11){
        self.ProductView.hidden = YES;
    }else{
        self.ProductView.hidden = NO;
        NSLog(@"%@",self.model.DynamicTitleV2);
        self.ProductView.frame = CGRectMake(8, CGRectGetMaxY(self.MessageLab.frame)+5, self.contentView.frame.size.width - 20, 112);
    }
    
}
-(void)setModel:(CustomDynamicModel *)model{
    _model = model;

//    if ([model.DynamicType intValue]==1) {
//        self.TitleImage.image = [UIImage imageNamed:@"dongtaixin"];
//    }else if([model.DynamicType intValue]==2){
//        self.TitleImage.image = [UIImage imageNamed:@"dongtaizhanghu"];
//    }else {
//        self.TitleImage.image = [UIImage imageNamed:@"dongtaichanpin"];
//    }

    if ([model.NickName isEqualToString:@""] || model.NickName.length<2) {
        self.nameLabel.text = model.NickName;
    }else{
        self.nameLabel.text = [model.NickName substringToIndex:1];
    }

    if ([NSString stringIsEmpty:model.HeadUrl]) {
        self.nameLabel.hidden = NO;
        [self.TitleImage sd_setImageWithURL:nil placeholderImage:nil];

    }else{
        self.nameLabel.hidden = YES;
        [self.TitleImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:nil];
    }
    
    
    self.TimeLabel.text = model.CreateTimeText;
    
    self.MessageLab.text = model.DynamicTitleV2;
    
    self.UserName.text = model.NickName;
//     self.UserName.text = @"我住在你女朋友的隔壁";
    //动态适配
    if (![self.UserName.text  isEqual: @""]) {
        self.UserName.text = model.NickName;;
    }else{
        self.UserName.text = @" ";
        
    }
   CGFloat width = [self.UserName.text widthWithsysFont:13];
    NSLog(@"%f---%f",self.UserName.frame.size.width,width);
    CGRect LastUserName = self.UserName.frame;
    LastUserName.size.width = width+5;
    self.UserName.frame = LastUserName;
    NSString *WXstr = model.WeixinNickName;

    NSString *WXFinStr;
    for (NSInteger i = 0; i < WXstr.length; i++) {
        NSLog(@"%C",[WXstr characterAtIndex:i]);
        if ([[NSString stringWithFormat:@"%C",[WXstr characterAtIndex:i]]  isEqual: @" "]) {
            WXFinStr = [WXstr substringFromIndex:i+1];
        }else{
            WXFinStr =[WXstr substringFromIndex:i];
            break;
        }
    }

    if (![WXstr  isEqual: @""]) {
        self.WXName.text = [NSString stringWithFormat:@"(%@)", WXFinStr];
    }else{
        self.WXName.text = @" ";

    }
    CGRect wxnameFrame = self.WXName.frame;
    wxnameFrame.origin.x = self.UserName.frame.origin.x+self.UserName.frame.size.width+5;
    self.WXName.frame = wxnameFrame;

    [self.ProductView.ProductImage sd_setImageWithURL:[NSURL URLWithString:model.ProductdetailModel.PicUrl] placeholderImage:[UIImage imageNamed:@"CommandplaceholderImage"]];//产品图片
    self.ProductView.ProductDescribtion.text = model.ProductdetailModel.Name;//产品描述
    self.ProductView.CodeNum.text = model.ProductdetailModel.Code;//产品编号
    
    self.ProductView.TonghangPrice.text  =[NSString stringWithFormat:@"%@",model.ProductdetailModel.PersonPeerPrice];//同行价   动态行宽
    CGFloat ProTonghWidth = [self.ProductView.TonghangPrice.text widthWithsysFont:20];
    CGRect TongHangRect = self.ProductView.TonghangPrice.frame;
    TongHangRect.size.width = ProTonghWidth+3;
    TongHangRect.origin.x = self.ProductView.tonghangRect.frame.origin.x-ProTonghWidth-5;
    self.ProductView.TonghangPrice.frame = TongHangRect;
    //人民币符号
    CGRect RMBCh = self.ProductView.RMBChina.frame;
    RMBCh.origin.x = self.ProductView.TonghangPrice.frame.origin.x - 8;
    self.ProductView.RMBChina.frame = RMBCh;
   
    //同行符号
    CGRect menshiRect = self.ProductView.menshiRect.frame;
    menshiRect.origin.x = self.ProductView.RMBChina.frame.origin.x-40;
    self.ProductView.menshiRect.frame = menshiRect;
    
    self.ProductView.MenshiPrice.text = [NSString stringWithFormat:@"¥%@",model.ProductdetailModel.PersonPrice] ;//门市价    动态行宽
    CGFloat PromenshiWidth = [self.ProductView.MenshiPrice.text widthWithsysFont:13];
    CGRect PromenshiRect = self.ProductView.MenshiPrice.frame;
    PromenshiRect.origin.x = self.ProductView.menshiRect.frame.origin.x-PromenshiWidth-5;
    PromenshiRect.size.width = PromenshiWidth+3;
    self.ProductView.MenshiPrice.frame = PromenshiRect;
}

//跳转客户资料界面
-(void)openIM{
//    VC.customerID = model.ID;
//    VC.IsOpenIM = model.IsOpenIM;
//    VC.InvitationInfo = self.InvitationInfo;

    CustomerDetailAndOrderViewController *Customer = [[CustomerDetailAndOrderViewController alloc] init];
    Customer.customerID = @"";
    Customer.AppSkbUserId = _model.AppSkbUserId;
    Customer.name = _model.ProductdetailModel.Name;
    if (self.cellvisitorDynamicFromType == CellVisitorDynamicTypeFromMessageCenter) {
        [self.NAV pushViewController:Customer animated:YES];
    }
   
}
-(void)openCustormDet{
    NSLog(@"点击跳转");
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CustormJumpToCustormDet"];
    CustomerDetailAndOrderViewController *Customer = [[CustomerDetailAndOrderViewController alloc] init];
    Customer.customerID = self.model.ProductdetailModel.ID;
    Customer.AppSkbUserId = _model.AppSkbUserId;
    Customer.appUserID = @"";
    Customer.name = _model.ProductdetailModel.Name;
    NSLog(@"%@", self.NAV);
    if (self.cellvisitorDynamicFromType == CellVisitorDynamicTypeFromMessageCenter) {
        [self.NAV pushViewController:Customer animated:YES];
    }
}

- (void)openProduct{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"ShouKeBao_customerDynamicMessageListClick" attributes:dict];
    
    NSString * productUrl = self.model.ProductdetailModel.LinkUrl;
    ProduceDetailViewController *detail = [[ProduceDetailViewController alloc] init];
    NSLog(@"%@", productUrl);
    detail.produceUrl = productUrl;
    detail.fromType = FromZhiVisitorDynamic;
    detail.shareInfo = self.model.ProductdetailModel.ShareInfo;
    [self.NAV pushViewController:detail animated:YES];
    
}
- (IBAction)MessageBtnClick:(UIButton *)sender {
        NSLog(@"%@", self.model.AppSkbUserId);
        ChatViewController * charV = [[ChatViewController alloc]initWithChatter:self.model.AppSkbUserId conversationType:eConversationTypeChat];
    if (self.cellvisitorDynamicFromType == CellVisitorDynamicTypeFromMessageCenter) {
        [self.NAV pushViewController:charV animated:YES];
    }
}
@end
