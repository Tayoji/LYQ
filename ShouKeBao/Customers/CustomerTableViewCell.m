//
//  CustomerTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/6.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "CustomerTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "IWHttpTool.h"
#import "MobClick.h"
#import "BaseClickAttribute.h"
#import "IChatManagerConversation.h"
#import "EaseMob.h"

@interface CustomerTableViewCell ()
@property (nonatomic, strong)UIView * redDot;

@end

@implementation CustomerTableViewCell



+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"CustomerTableViewCell";
    CustomerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(CustomModel *)model{
    _model = model;
    NSUInteger unreaderMessageCount = [[EaseMob sharedInstance].chatManager unreadMessagesCountForConversation:self.model.AppSkbUserId];
    
    if (unreaderMessageCount) {
        self.redDot.hidden = NO;
    }else{
        self.redDot.hidden = YES;
    }

    self.customerIcon.layer.masksToBounds = YES;
    self.customerIcon.layer.cornerRadius = 20;
    self.customerIcon.backgroundColor = [UIColor orangeColor];
    
    
    if ([[NSString stringWithFormat:@"%@", model.HearUrl] isEqualToString:@""]) {
        
        NSString *a = [[NSString stringWithFormat:@"%@", model.Name] substringToIndex:1];
        NSMutableAttributedString *aa = [[NSMutableAttributedString alloc] initWithString:a];
        [aa addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
        [aa addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
        [self.customerIcon1 setAttributedTitle:aa forState:UIControlStateNormal];
    }else{
        
        [self.customerIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.HearUrl]]];
    }
    self.nameL.text = model.Name;

    NSString *pattern = @"\\d";//@"[0-9]"
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:model.Mobile options:0 range:NSMakeRange(0, model.Mobile.length)];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        [arr addObject:[model.Mobile substringWithRange:result.range]];
    }
    NSString *tel = [NSString string];
    for (NSInteger i = 0; i < arr.count; i++) {
        tel = [tel stringByAppendingString:arr[i]];
    }
    self.telStr = tel;
    self.telL.text = [NSString stringWithFormat:@"电话：%@",tel];
    self.orderL.text = [NSString stringWithFormat:@"订单数：%@",model.OrderCount];
    
    if ([self.model.IsOpenIM integerValue] == 0) {
        NSString *isGray_redID = [NSString stringWithFormat:@"isGray_red%@", self.model.ID];
        NSLog(@"isGray_redID  = %@", isGray_redID );
        if (![[NSUserDefaults standardUserDefaults]boolForKey:isGray_redID]) {
            self.redDot.hidden = NO;
        }else{
            self.redDot.hidden = YES;
        }
        [self.IMBtn setImage:[UIImage imageNamed:@"grayxiaoxi"] forState:UIControlStateNormal];
    }
    
}

-(UIView *)redDot{
    if (!_redDot) {
        _redDot = [[UIView alloc]initWithFrame:CGRectMake(self.IMBtn.frame.size.width*2/3-2, 2, 8, 8)];
        _redDot.backgroundColor = [UIColor redColor];
        _redDot.layer.cornerRadius = 4.0;
        _redDot.layer.masksToBounds = YES;
    }
    return _redDot;
}

- (void)awakeFromNib {
    [self.IMBtn addSubview:self.redDot];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickIconToCustomerDetail:(id)sender {
//    if (_delegate && [_delegate respondsToSelector:@selector(pushCustomerDetailVC:AppSkbUserId: name: IsOpenIM:)]) {
//        [_delegate pushCustomerDetailVC:self.model.ID AppSkbUserId:self.model.AppSkbUserId name:self.model.Name IsOpenIM:self.model.IsOpenIM];
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(pushCustomerDetailVC:)]) {
        [_delegate pushCustomerDetailVC:self.model];
    }
}

- (IBAction)clickIMBtnAction:(id)sender {
    
    if ([self.model.IsOpenIM integerValue] == 0) {
        NSString *isGray_redID = [NSString stringWithFormat:@"isGray_red%@", self.model.ID];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isGray_redID];
        
        if (_delegate && [_delegate respondsToSelector:@selector(tipInviteViewShow:)]) {
            [_delegate tipInviteViewShow:self.telStr];
            [_delegate tableViewReloadData];
        }
    }else{
        BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
        [MobClick event:@"Customer_newCustomerIMChatIconClick" attributes:dict];
        if (_delegate && [_delegate respondsToSelector:@selector(transformPerformation:)]) {
            [_delegate transformPerformation:self.model];
        }
    }
    
}

- (IBAction)takePhoneAction:(id)sender {
    [self callAction];
}

- (void)callAction{
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"CustomCallClick" attributes:dict];
    
    if (self.telStr.length>6) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.telStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else if (self.telStr.length<=6){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"该客户电话号码错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        
    }
}


@end
