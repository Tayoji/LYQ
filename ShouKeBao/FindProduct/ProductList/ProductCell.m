//
//  ProductCell.m
//  ShouKeBao
//
//  Created by David on 15/3/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ProductCell.h"
#import "UIImageView+WebCache.h"
#import "textStyle.h"
#import "UIImage+QD.h"
#import "WMAnimations.h"
#import "MyListViewController.h"

#import "NSString+FKTools.h"

@interface ProductCell()
@property (nonatomic, copy)NSString * productId;
@property (nonatomic)UILabel *lastDateL;

@end

@implementation ProductCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"productCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isHistory = NO;
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 历史浏览的内容
    UILabel *time = [[UILabel alloc] init];
    time.textAlignment = NSTextAlignmentRight;
    time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:time];
    self.time = time;
    
    UIView *sep = [[UIView alloc] init];
    sep.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [self.contentView addSubview:sep];
    self.sep = sep;
    
    /*
     图片 标题 出发
     */
    UILabel *title = [[UILabel alloc] init];
    //    title.textAlignment = UIControlContentVerticalAlignmentTop;
    //    title.textAlignment = UIControlContentVerticalAlignmentFill;
    //    [title setVerticalAlignment:VerticalAlignmentTop];
   
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:15];
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
    ShanDianBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    
    ShanDianBtn.userInteractionEnabled = NO;
    ShanDianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    ShanDianBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.icon addSubview:ShanDianBtn];
    self.ShanDianBtn = ShanDianBtn;
    
    /*
     两个价格lable和一个分界线
     */
    UILabel *normalPrice = [[UILabel alloc] init];
    normalPrice.font = [UIFont systemFontOfSize:12];
    normalPrice.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:normalPrice];
    self.normalPrice = normalPrice;
    
    UILabel *cheapPrice = [[UILabel alloc] init];
    cheapPrice.font = [UIFont systemFontOfSize:12];
    cheapPrice.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:cheapPrice];
    self.cheapPrice = cheapPrice;
    
    UILabel *lastDateL = [[UILabel alloc]init];
    lastDateL.textColor = [UIColor lightGrayColor];
    lastDateL.font = [UIFont systemFontOfSize:12.0f];
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
    productNum.font = [UIFont systemFontOfSize:12];
    productNum.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:productNum];
    self.productNum = productNum;
    
    UILabel * diLab = [[UILabel alloc]init];
    [self.contentView  addSubview:diLab];
    self.diLab = diLab;
    UIButton *di = [[UIButton alloc]init];
    [di setBackgroundImage:[UIImage imageNamed:@"red-2"] forState:(UIControlStateNormal)];
    di.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [di setTitle:@"抵" forState:UIControlStateNormal];
    //    di.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.diLab addSubview:di];
    self.di = di;
    
    
    UILabel * songLab = [[UILabel alloc]init];
    songLab.textColor = [UIColor colorWithRed:253/255.0 green:134/255.0 blue:39/255.0 alpha:1.0];
    [self.contentView addSubview:songLab];
    self.songLab = songLab;
    UIButton *song = [[UIButton alloc]init];
    [song setBackgroundImage:[UIImage imageNamed:@"orange"] forState:(UIControlStateNormal)];
    song.titleLabel.font = [UIFont boldSystemFontOfSize:13];
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
    li.titleLabel.font = [UIFont boldSystemFontOfSize:13];
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
    /*
     下架产品
     */
    UILabel * theView = [[UILabel alloc]init];
    theView.textAlignment = NSTextAlignmentCenter;
    theView.textColor = [UIColor lightGrayColor];
    theView.text = @"此产品已下架";
    self.undercarriageView = theView;
    //    [WMAnimations WMAnimationMakeBoarderWithLayer:theView.layer andBorderColor:[UIColor lightGrayColor] andBorderWidth:0.5 andNeedShadow:NO andCornerRadius:3];
    self.undercarriageView.font = [UIFont systemFontOfSize:16];
    self.undercarriageView.textColor = [UIColor grayColor];
    self.undercarriageView.hidden = YES;
    self.undercarriageView.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:theView];
    //相关按钮
    UIButton * RelatedBt = [[UIButton alloc]init];
    self.RelatedBtn = RelatedBt;
    self.RelatedBtn.titleLabel.textColor = [UIColor whiteColor];
    [self.RelatedBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    self.RelatedBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:132/255.0 blue:250/155.0 alpha:1.0];
    [self.RelatedBtn setTitle:@"查看相关产品" forState:UIControlStateNormal];
    [self.RelatedBtn addTarget:self action:@selector(RelatedProductClick) forControlEvents:UIControlEventTouchUpInside];
    [WMAnimations WMAnimationMakeBoarderWithLayer:self.RelatedBtn.layer andBorderColor:[UIColor clearColor] andBorderWidth:1.0 andNeedShadow:NO andCornerRadius:3];
    self.RelatedBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.RelatedBtn.hidden = YES;
    [self.contentView addSubview:RelatedBt];
    //分割线
    //    UIView *line = [[UIView alloc] init];
    //    line.backgroundColor = [UIColor colorWithRed:170/255.f green:170/255.f blue:170/255.f alpha:1];
    //    [self.contentView addSubview:line];
    //    self.line = line;
        UIView *cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:244/255.f alpha:1];
        [self.contentView addSubview:cellView];
        self.cellView = cellView;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat titleY = 8;
    CGFloat iconWidth;
    
//    if (self.isHistory) {
//        iconWidth = 72;
//    }else{
        iconWidth = 72;
//    }

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
    
    /**
     四个label 产品编号 抵 送 利 闪电
     */
    //产品编号
    CGFloat productNumWidth = screenW/3;
    CGFloat productNumHS = CGRectGetMidY(self.line.frame);
    CGFloat productNumHeight;
    if (self.isHistory) {
        productNumHeight = height- productNumHS-40+4;
    }else{
        productNumHeight = height- productNumHS;
    }
    
    self.productNum.frame = CGRectMake(gap, productNumHS, productNumWidth, productNumHeight);
    CGFloat gaps;
    CGFloat gapScreen;
    CGFloat jW;
    CGFloat qW;
    CGFloat liW;
    if (screenW==320) {
        gapScreen = 5;
        gaps = 0;
        //        375:60 = 320:x
        jW = self.fanIsZero ? 57 : 0;
        qW = self.quanIsZero ? 57 : 0;
        liW = 57;
    }else{
        gapScreen = screenW/17;
        gaps = screenW/100;
        jW = self.fanIsZero ? 60 : 0;
        qW = self.quanIsZero ? 60 : 0;
        liW = 60;
    }

    NSString *li = @"利";
    CGFloat w = [li widthWithsysFont:14];
    CGFloat h = [li heigthWithsysFont:13 withWidth:w];
    // 闪电
    CGFloat fW = self.isFlash ? 15 : 0;
    CGFloat fX = screenW-gap-fW;
    CGFloat fh;
    if (self.isHistory) {
        fh = (height - productNumHS -55)/2+productNumHS;
    }else{
        fh = (height - productNumHS -h)/2+productNumHS;
    }
    
    self.flash.frame = CGRectMake(fX, fh, fW, h);
    
    //利
    //  无论有没有闪电，利的横坐标都是确定的 而不能因为没有闪电就取代闪电的位置
    CGFloat profitWS = screenW-gap-15-gaps-liW;
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
    /*
     下架产品
     */
    self.undercarriageView.frame = CGRectMake(titleStart, priceYStart, priceWidth, priceHeight);
    CGFloat reS = CGRectGetMaxY(self.undercarriageView.frame)+(productNumHeight-45)/2;
    NSLog(@".. %f", screenW);
    if (screenW == 414) {
        self.RelatedBtn.frame = CGRectMake(screenW*2/3+gap, reS, screenW/3-2*gap, 30);
    }else if(screenW == 375){
        self.RelatedBtn.frame = CGRectMake(screenW*2/3, reS, screenW/3-gap, 30);
    }else{
        self.RelatedBtn.frame = CGRectMake(screenW*2/3-2*gap, reS, screenW/3+gap, 30);
    }
    
    if (self.isHistory) {
        CGFloat sepY = CGRectGetMaxY(self.productNum.frame);
        self.sep.frame = CGRectMake(gap, sepY, screenW - gap * 2, 1);
    }else{
        CGFloat sepY = CGRectGetMaxY(self.RelatedBtn.frame) + gap;
        self.sep.frame = CGRectMake(gap, sepY, screenW - gap * 2, 1);
    }

    
    CGFloat timeW = screenW - gap * 2;
    CGFloat timeX = screenW - timeW - gap;
    self.time.frame = CGRectMake(timeX, CGRectGetMaxY(self.sep.frame), timeW, 25);
    
    if (self.isHistory) {
      self.cellView.frame = CGRectMake(0, CGRectGetMaxY(self.time.frame), screenW, 15);
    }
   
    
    
}

- (void)setModal:(ProductModal *)modal{
    _modal = modal;
    self.productId = modal.ID;
    if (!self.isHistory) {
        self.time.hidden = YES;
        self.sep.hidden = YES;
    }
    
    // 历史时间
    self.time.text = [NSString stringWithFormat:@"浏览时间: %@",modal.HistoryViewTime];
    self.fanIsZero = [modal.PersonAlternateCash integerValue];
    self.quanIsZero = [modal.SendCashCoupon integerValue];
    [self.icon sd_setImageWithURL:[[NSURL alloc] initWithString:modal.PicUrl] placeholderImage:[UIImage imageNamed:@"lvyouquanIcon"]];
        self.title.text = modal.Name;
    /**
     *  四个label
     */
    //self.productNum.text = [NSString stringWithFormat:@"产品编号: %@",modal.Code];
    NSMutableAttributedString *normalStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@门市",modal.PersonPrice]];
    [normalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, modal.PersonPrice.length + 1)];
    [normalStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, modal.PersonPrice.length + 1)];
    self.normalPrice.attributedText = normalStr;
    
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@同行",modal.PersonPeerPrice]];
    [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:NSMakeRange(1, modal.PersonPeerPrice.length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, modal.PersonPeerPrice.length+1)];
    self.cheapPrice.attributedText = str1;
    
    self.lastDateL.text = [NSString stringWithFormat:@"最近班期：%@", modal.LastScheduleDate];
    
    NSString *codeStr = [NSString stringWithFormat:@"编号: %@",modal.Code];
    self.productNum.text = codeStr;
    [textStyle textStyleLabel:self.productNum text:codeStr FontNumber:13 AndRange:NSMakeRange(0, codeStr.length) AndColor:[UIColor lightGrayColor]];
    
    NSString *diStr = [NSString stringWithFormat:@"抵 ￥%@",modal.PersonAlternateCash];
    self.diLab.text = diStr;
    [textStyle textStyleLabel:self.diLab text:diStr FontNumber:12 Range:NSMakeRange(0, diStr.length) AndHaveRange:NSMakeRange(0, 1) AndHaveColor:[UIColor clearColor] BackGroundColor:[UIColor clearColor] AndNoHaveRange:NSMakeRange(2, diStr.length-2) AndnoHaveBackGroundColor:[UIColor redColor]];
    
    NSString *songStr = [[NSString alloc] initWithString:[NSString stringWithFormat:@"送 ￥%@",modal.SendCashCoupon]];
    self.songLab.text = songStr;
    [textStyle textStyleLabel:self.songLab text:songStr FontNumber:12 Range:NSMakeRange(0, songStr.length) AndHaveRange:NSMakeRange(0, 1) AndHaveColor:[UIColor clearColor] BackGroundColor:[UIColor clearColor] AndNoHaveRange:NSMakeRange(2, songStr.length-2) AndnoHaveBackGroundColor:[UIColor orangeColor]];
    
    NSString *str2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"利 ￥%@",modal.PersonProfit]];
    self.profits.text = str2;
    [textStyle textStyleLabel:self.profits text:str2 FontNumber:12 Range:NSMakeRange(0, str2.length) AndHaveRange:NSMakeRange(0, 1) AndHaveColor:[UIColor clearColor] BackGroundColor:[UIColor clearColor] AndNoHaveRange:NSMakeRange(2, str2.length - 2) AndnoHaveBackGroundColor:[UIColor redColor]];
    
    [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@出发",modal.StartCityName] forState:UIControlStateNormal];
    if ([modal.StartCityName isEqualToString:@"不限"]) {
        [self.ShanDianBtn setTitle:[NSString stringWithFormat:@"%@",modal.StartCityName] forState:UIControlStateNormal];
    }
    
    [self.ShanDianBtn sizeToFit];
    
    self.isFlash = [modal.IsComfirmStockNow integerValue];
    if ([modal.IsOffLine isEqualToString:@"1"]) {
        NSLog(@"%@", modal.ID);
        self.normalPrice.hidden = YES;
        self.cheapPrice.hidden = YES;
        self.profits.hidden = YES;
        self.flash.hidden = YES;
        self.ShanDianBtn.hidden = YES;
        self.diLab.hidden = YES;
        self.li.hidden = YES;
        self.line.hidden = YES;
        self.songLab.hidden = YES;
        self.undercarriageView.hidden = NO;
        self.RelatedBtn.hidden = NO;
        self.lastDateL.hidden = YES;
    }else{
        self.lastDateL.hidden = NO;
        self.normalPrice.hidden = NO;
        self.cheapPrice.hidden = NO;
        self.profits.hidden = NO;
        self.flash.hidden = NO;
        self.ShanDianBtn.hidden = NO;
        self.diLab.hidden = NO;
        self.li.hidden = NO;
        self.line.hidden = NO;
        self.songLab.hidden = NO;
        self.undercarriageView.hidden = YES;
        self.RelatedBtn.hidden = YES;
    }
    [self setNeedsLayout];
    
}
- (void)RelatedProductClick{
    MyListViewController * MLVC = [[MyListViewController alloc]init];
    MLVC.listType = RelatedProductType;
    MLVC.productId = self.productId;
    [self.MylistVCNav pushViewController:MLVC animated:YES];
}


@end
