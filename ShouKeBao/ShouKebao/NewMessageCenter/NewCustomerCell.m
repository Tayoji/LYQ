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
@interface NewCustomerCell ()<UIWebViewDelegate>
- (IBAction)MessageBtnClick:(UIButton *)sender;

@end

@implementation NewCustomerCell
- (void)awakeFromNib {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openIM)];
    [self.TitleImage addGestureRecognizer:tap];
    VisitorDynamicProductView * productView = [[[NSBundle mainBundle] loadNibNamed:@"VisitorDynamicProductView" owner:nil options:nil] lastObject];
    self.ProductView = productView;
    self.ProductView.hidden = YES;
    [self addSubview:self.ProductView];
}
-(void)layoutSubviews{
    CGFloat Messagelabh = [self.model.DynamicTitleV2 heigthWithsysFont:14 withWidth:self.MessageLab.frame.size.width];
    CGRect Messagelabf = CGRectMake(self.MessageLab.frame.origin.x, self.MessageLab.frame.origin.y, self.MessageLab.frame.size.width, Messagelabh);
    self.MessageLab.frame = Messagelabf;
    
    if ([self.model.DynamicType intValue] == 1 || [self.model.DynamicType intValue] == 2||[self.model.DynamicType intValue] == 3||[self.model.DynamicType intValue] == 9){
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
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    label.text = [model.NickName substringToIndex:1];
    label.backgroundColor = [UIColor colorWithRed:61/255.0 green:156/255.0 blue:177/255.0 alpha:1];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    label.font = [UIFont boldSystemFontOfSize:18];
    
    if ([model.HeadUrl isEqualToString:@""]) {
        [self.TitleImage addSubview:label];
    }else{
        [label removeFromSuperview];
        [self.TitleImage sd_setImageWithURL:[NSURL URLWithString:model.HeadUrl] placeholderImage:nil];
    }
    
    
    self.TimeLabel.text = model.CreateTimeText;
    
    self.MessageLab.text = model.DynamicTitleV2;
    self.UserName.text = model.NickName;
    
    
    self.WXName.text = [NSString stringWithFormat:@"(%@)", model.WeixinNickName];
    
    [self.ProductView.ProductImage sd_setImageWithURL:[NSURL URLWithString:model.ProductdetailModel.PicUrl] placeholderImage:[UIImage imageNamed:@"CommandplaceholderImage"]];//产品图片
    self.ProductView.ProductDescribtion.text = model.ProductdetailModel.Name;//产品描述
    self.ProductView.CodeNum.text = model.ProductdetailModel.Code;//产品编号
    self.ProductView.MenshiPrice.text = model.ProductdetailModel.PersonPrice;//门市价
    self.ProductView.TonghangPrice.text  = model.ProductdetailModel.PersonPeerPrice;//同行价
    
    
}

//跳转IM界面
-(void)openIM{
    NSLog(@"%@", self.model.AppSkbUserId);
    ChatViewController * charV = [[ChatViewController alloc]initWithChatter:self.model.AppSkbUserId conversationType:eConversationTypeChat];
    [self.NAV pushViewController:charV animated:YES];
}



- (IBAction)MessageBtnClick:(UIButton *)sender {
    [self openIM];
}
@end
