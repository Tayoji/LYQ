//
//  ChoseEveryDayTableViewCell.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/22.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ChoseEveryDayTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "textStyle.h"
#import "UIImage+QD.h"
#import "WMAnimations.h"
#import "MyListViewController.h"
#import "NSString+FKTools.h"
#define type 0.9
@interface ChoseEveryDayTableViewCell()
@property (weak, nonatomic) UILabel *title;
@property (weak, nonatomic) UIImageView *icon;
@property (weak, nonatomic) UILabel *productNum;
@property (weak, nonatomic) UILabel *normalPrice;
@property (weak, nonatomic) UILabel *cheapPrice;
@property (weak, nonatomic) UILabel *profits;
@property (weak, nonatomic) UILabel *diLab;
@property (weak, nonatomic) UILabel *songLab;

@property (weak, nonatomic) UIButton *li;
@property (weak, nonatomic) UIButton *di;
@property (weak, nonatomic) UIButton *song;
@property (weak, nonatomic) UIButton *jiafanBtn;
@property (weak, nonatomic) UIButton *quanBtn;
@property (weak, nonatomic) UIButton *ShanDianBtn;
@property (nonatomic,weak) UIButton *flash;
@property (nonatomic,weak) UILabel *time;// 浏览时间
@property (nonatomic,weak) UIView *line;// xixian
@property (nonatomic,weak) UIView *sep;// 线条
@property (nonatomic,weak) UIView *cellView;//
@property (nonatomic, strong)UILabel *lastScheduleDateLab;//最近班期
@property (nonatomic, copy)NSString * productId;
@property (nonatomic)UILabel *lastDateL;
@end
static NSString *cellID = @"theChoseEveryDayTableViewCell";

@implementation ChoseEveryDayTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    ChoseEveryDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ChoseEveryDayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHistory = NO;
        [self setup];
    }
    return self;
}

- (void)setup{
    UILabel *title = [[UILabel alloc] init];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:15*type];
    [self.contentView addSubview:title];
    self.title = title;
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.layer.cornerRadius = 5;
    icon.layer.masksToBounds = YES;
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    // 出发
    UIButton *ShanDianBtn = [[UIButton alloc] init];
    ShanDianBtn.backgroundColor = [UIColor blackColor];
    ShanDianBtn.alpha = 0.7;
    [ShanDianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ShanDianBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11*type];
    
    ShanDianBtn.userInteractionEnabled = NO;
    ShanDianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShanDianBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.icon addSubview:ShanDianBtn];
    self.ShanDianBtn = ShanDianBtn;
    
    /*
     两个价格lable和一个分界线
     */
    UILabel *normalPrice = [[UILabel alloc] init];
    normalPrice.font = [UIFont systemFontOfSize:12*type];
    normalPrice.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:normalPrice];
    self.normalPrice = normalPrice;
    
    UILabel *cheapPrice = [[UILabel alloc] init];
    cheapPrice.font = [UIFont systemFontOfSize:12*type];
    cheapPrice.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:cheapPrice];
    self.cheapPrice = cheapPrice;
    
    UILabel *lastDateL = [[UILabel alloc]init];
    lastDateL.textColor = [UIColor lightGrayColor];
    lastDateL.font = [UIFont systemFontOfSize:13.0f*type];
    lastDateL.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:lastDateL];
    self.lastDateL = lastDateL;
    
    
    UIView *line = [[UIView alloc]init];
    [self.contentView addSubview:line];
    line.backgroundColor = [UIColor blackColor];
    line.alpha = 0.1;
    self.line = line;
    
    
    /**
     底部4个label 和 闪电图片
     */
    UILabel *productNum = [[UILabel alloc] init];
    productNum.font = [UIFont systemFontOfSize:13*type];
    productNum.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:productNum];
    self.productNum = productNum;
    
    UILabel * diLab = [[UILabel alloc]init];
    [self.contentView  addSubview:diLab];
    self.diLab = diLab;
    UIButton *di = [[UIButton alloc]init];
    [di setBackgroundImage:[UIImage imageNamed:@"red-2"] forState:(UIControlStateNormal)];
    di.titleLabel.font = [UIFont boldSystemFontOfSize:13*type];
    [di setTitle:@"抵" forState:UIControlStateNormal];
    [self.diLab addSubview:di];
    self.di = di;
    
    
    UILabel * songLab = [[UILabel alloc]init];
    songLab.textColor = [UIColor colorWithRed:253/255.0 green:134/255.0 blue:39/255.0 alpha:1.0];
    [self.contentView addSubview:songLab];
    self.songLab = songLab;
    UIButton *song = [[UIButton alloc]init];
    [song setBackgroundImage:[UIImage imageNamed:@"orange"] forState:(UIControlStateNormal)];
    song.titleLabel.font = [UIFont boldSystemFontOfSize:13*type];
    [song setTitle:@"送" forState:UIControlStateNormal];
    song.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.songLab addSubview:song];
    self.song = song;
    
    
    UILabel *profits = [[UILabel alloc] init];
    profits.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:profits];
    self.profits = profits;
    UIButton *li = [[UIButton alloc]init];
    [li setBackgroundImage:[UIImage imageNamed:@"white-3"] forState:(UIControlStateNormal)];
    li.titleLabel.font = [UIFont boldSystemFontOfSize:13*type];
    [li setTitle:@"利" forState:UIControlStateNormal];
    [li setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    li.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.profits addSubview:li];
    self.li = li;
    
    // 闪电
    UIButton *flash = [[UIButton alloc] init];
    [flash setImage:[UIImage imageNamed:@"sandian"]forState:UIControlStateNormal];
    [self.contentView addSubview:flash];
    self.flash = flash;
    
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:244/255.f alpha:1];
    [self.contentView addSubview:cellView];
    self.cellView = cellView;
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width-20;
    CGFloat titleY = 8;
    CGFloat iconWidth;
   
    iconWidth = 72*type;
    /*
     图片 标题 出发地
     */
    self.icon.frame = CGRectMake(gap, titleY, iconWidth, iconWidth);
    self.ShanDianBtn.frame = CGRectMake(0, iconWidth*3/4, iconWidth, iconWidth/4);
    
    CGFloat titleStart = CGRectGetMaxX(self.icon.frame)+gap/2;
    CGFloat titleW = screenW - gap - titleStart;
    self.title.frame = CGRectMake(titleStart, titleY-2, titleW, iconWidth*2/3);//产品名称
    /**
     门市价 同行价 分界线
     */
    //门市价
    CGFloat priceYStart = CGRectGetMaxY(self.title.frame);
    CGFloat normalWidth = screenW/3;
    CGFloat priceHeight = CGRectGetMaxY(self.icon.frame)/3;
    self.normalPrice.frame = CGRectMake(titleStart, priceYStart, normalWidth, iconWidth/3);
    // 同行价
    CGFloat samePriceWStart = screenW*3/5;
    CGFloat priceWidth = screenW*2/5-gap;
    self.cheapPrice.frame = CGRectMake(samePriceWStart, priceYStart, priceWidth, iconWidth/3);
    //最近班期
    self.lastDateL.frame = CGRectMake(titleStart, CGRectGetMaxY(self.normalPrice.frame), screenW-titleStart-gap, iconWidth/3);
    
    //   细分界线
    CGFloat lineYS = CGRectGetMaxY(self.lastDateL.frame);
    self.line.frame = CGRectMake(titleStart, lineYS, titleW, 0.5);
    
    CGFloat productNumWidth = screenW/3;
    CGFloat productNumHS = CGRectGetMidY(self.line.frame);
    CGFloat productNumHeight;
    productNumHeight = height- productNumHS;

    self.productNum.frame = CGRectMake(gap, productNumHS, productNumWidth, productNumHeight);
    CGFloat gaps;
    CGFloat gapScreen;
    CGFloat jW;
    CGFloat qW;
    CGFloat liW;
    if (screenW==320) {
        gapScreen = 5;
        gaps = 0;
        jW = self.fanIsZero ? 57*type : 0;
        qW = self.quanIsZero ? 57*type : 0;
        liW = 57*0.85;
        
    }else{
        gapScreen = screenW/17;
        gaps = screenW/100;
        jW = self.fanIsZero ? 60*type : 0;
        qW = self.quanIsZero ? 60*type : 0;
        liW = 60*0.85;
    }
    
    NSString *li = @"利";
    CGFloat w = [li widthWithsysFont:14*type];
    CGFloat h = [li heigthWithsysFont:13*type withWidth:w];
    // 闪电
    CGFloat fW = self.isFlash ? 15*0.85 : 0;
    CGFloat fX = screenW-gap-fW;
    CGFloat fh;
    
    fh = (height - productNumHS -h)/2+productNumHS;
    self.flash.frame = CGRectMake(fX, fh, fW, h);
    
    //利
    //  无论有没有闪电，利的横坐标都是确定的 而不能因为没有闪电就取代闪电的位置
//    CGFloat profitWS = screenW-gap-15-gaps-liW;
    CGFloat profitWS = screenW-gap-15*0.85-gaps-liW;
    self.profits.frame = CGRectMake(profitWS, productNumHS, liW, productNumHeight);
    CGFloat hStart = (productNumHeight - h)/2;
    self.li.frame = CGRectMake(0, hStart, h, h);
    
    
    //  送
    CGFloat songLabWS = profitWS-gaps-qW;
    self.songLab.frame = CGRectMake(songLabWS, productNumHS, qW, productNumHeight);
    if (self.quanIsZero) {
        self.song.frame = CGRectMake(0, hStart, h, h);
    }else{
        self.song.frame = CGRectMake(0, hStart, 0, h);
    }
    
    //  抵
    CGFloat diLabWS = songLabWS-gaps-jW;
    self.diLab.frame = CGRectMake(diLabWS, productNumHS, jW, productNumHeight);
    if (self.fanIsZero) {
        self.di.frame = CGRectMake(0, hStart, h, h);
    }else{
        self.di.frame = CGRectMake(0, hStart, 0, h);
    }
}


- (void)setModal:(ProductModal *)modal{
    _modal = modal;
    if (!_modal) {
        return;
    }
    self.productId = modal.ID;
    if (!self.isHistory) {
        self.time.hidden = YES;
        self.sep.hidden = YES;
    }
    NSLog(@".. %@ %@ %@", modal.ID, modal.PushDate, modal.Name);
    // 历史时间
    self.time.text = [NSString stringWithFormat:@"浏览时间: %@",modal.HistoryViewTime];
    self.fanIsZero = [modal.PersonAlternateCash integerValue];
    self.quanIsZero = [modal.SendCashCoupon integerValue];
    [self.icon sd_setImageWithURL:[[NSURL alloc] initWithString:modal.PicUrl] placeholderImage:[UIImage imageNamed:@"lvyouquanIcon"]];
    self.title.text = modal.Name;
    /**
     *  四个label
     */
    NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@门市",modal.PersonPrice]];
    [normalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, modal.PersonPrice.length + 1)];
    [normalStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, modal.PersonPrice.length + 1)];
    self.normalPrice.attributedText = normalStr;
    
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@同行",modal.PersonPeerPrice]];
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23*type] range:NSMakeRange(1, modal.PersonPeerPrice.length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, modal.PersonPeerPrice.length+1)];
    self.cheapPrice.attributedText = str1;
    
    self.lastDateL.text = [NSString stringWithFormat:@"最近班期：%@", modal.LastScheduleDate];
    
    NSString *codeStr = [NSString stringWithFormat:@"编号: %@",modal.Code];
    self.productNum.text = codeStr;
    [textStyle textStyleLabel:self.productNum text:codeStr FontNumber:13*type AndRange:NSMakeRange(0, codeStr.length) AndColor:[UIColor lightGrayColor]];
    
    NSString *diStr = [NSString stringWithFormat:@"抵 ￥%@",modal.PersonAlternateCash];
    self.diLab.text = diStr;
    [textStyle textStyleLabel:self.diLab text:diStr FontNumber:12*type Range:NSMakeRange(0, diStr.length) AndHaveRange:NSMakeRange(0, 1) AndHaveColor:[UIColor clearColor] BackGroundColor:[UIColor clearColor] AndNoHaveRange:NSMakeRange(2, diStr.length-2) AndnoHaveBackGroundColor:[UIColor redColor]];
    
    NSString *songStr = [[NSString alloc] initWithString:[NSString stringWithFormat:@"送 ￥%@",modal.SendCashCoupon]];
    self.songLab.text = songStr;
    [textStyle textStyleLabel:self.songLab text:songStr FontNumber:12*type Range:NSMakeRange(0, songStr.length) AndHaveRange:NSMakeRange(0, 1) AndHaveColor:[UIColor clearColor] BackGroundColor:[UIColor clearColor] AndNoHaveRange:NSMakeRange(2, songStr.length-2) AndnoHaveBackGroundColor:[UIColor orangeColor]];
    
    NSString *str2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"利 ￥%@",modal.PersonProfit]];
    self.profits.text = str2;
    [textStyle textStyleLabel:self.profits text:str2 FontNumber:12*type Range:NSMakeRange(0, str2.length) AndHaveRange:NSMakeRange(0, 1) AndHaveColor:[UIColor clearColor] BackGroundColor:[UIColor clearColor] AndNoHaveRange:NSMakeRange(2, str2.length - 2) AndnoHaveBackGroundColor:[UIColor redColor]];
    
    [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@出发",modal.StartCityName] forState:UIControlStateNormal];
    if ([modal.StartCityName isEqualToString:@"不限"]) {
        [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@",modal.StartCityName] forState:UIControlStateNormal];
    }
    [self.ShanDianBtn sizeToFit];
    
    self.isFlash = [modal.IsComfirmStockNow integerValue];
    [self setNeedsLayout];
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
