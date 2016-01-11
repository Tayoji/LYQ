//
//  FKReceiveProductLinkView.m
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/11.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "FKReceiveProductLinkView.h"
#import "ProductModal.h"
#import "UIImageView+EMWebCache.h"
@interface FKReceiveProductLinkView ()
@property (nonatomic, strong)UIImageView * productImage;
@property (nonatomic, strong)UILabel * startCityLable;


@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * startDayLabel;



@end

@implementation FKReceiveProductLinkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViewsWithFrame:frame];
    }
    return self;
}
- (void)setUpSubViewsWithFrame:(CGRect)frame{
    //页面布局
    self.productImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 60, 60)];
    self.productImage.backgroundColor = [UIColor clearColor];
    [self addSubview:self.productImage];
    
    UIView * alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 47, self.productImage.frame.size.width, 13)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.5;
    [self.productImage addSubview:alphaView];
    
    self.startCityLable = [[UILabel alloc]initWithFrame:alphaView.frame];
    self.startCityLable.font = [UIFont systemFontOfSize:10];
    self.startCityLable.textColor = [UIColor whiteColor];
    self.startCityLable.textAlignment = NSTextAlignmentCenter;
    self.startCityLable.text = @"上海出发";
    [self.productImage addSubview:self.startCityLable];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.productImage.frame)+2, CGRectGetMinY(self.productImage.frame), frame.size.width - 68, 40)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.text = @"内蒙古草原骑马放羊遛狗赶鸭子，全程帐篷，自由释放";
    [self addSubview:self.titleLabel];
    
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 25, CGRectGetMaxY(self.titleLabel.frame) + 5, 20, 20)];
    rightLabel.text = @"起";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = [UIFont systemFontOfSize:15];
    rightLabel.textColor = [UIColor grayColor];
    [self addSubview:rightLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 76, CGRectGetMinY(rightLabel.frame), 50, 20)];
    self.priceLabel.text = @"6787";
    self.priceLabel.font = [UIFont systemFontOfSize:19];
    self.priceLabel.textColor = [UIColor colorWithRed:252/255.0 green:102/255.0 blue:34/255.0 alpha:1.0];
    [self addSubview:self.priceLabel];
    
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 86, CGRectGetMinY(rightLabel.frame) + 5, 10, 15)];
    leftLabel.text = @"¥";
    leftLabel.font = [UIFont systemFontOfSize:13];
    leftLabel.textColor = [UIColor colorWithRed:252/255.0 green:102/255.0 blue:34/255.0 alpha:1.0];
    [self addSubview:leftLabel];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.productImage.frame) + 8, frame.size.width - 10, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [self addSubview:lineView];
    
    self.startDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(lineView.frame) + 5, frame.size.width - 8, 20)];
    self.startDayLabel.font = [UIFont systemFontOfSize:12];
    self.startDayLabel.text = @"2016/01/29, 出发回家";
    self.startDayLabel.textColor = [UIColor grayColor];
    [self addSubview:self.startDayLabel];
}

+ (FKReceiveProductLinkView *)FKProductViewWithModel:(ProductModal *)model
                                            andFrame:(CGRect)frame{
    FKReceiveProductLinkView * FKV = [[FKReceiveProductLinkView alloc]initWithFrame:frame];
    //根据model传进来值进行赋值
    [FKV.productImage sd_setImageWithURL:[NSURL URLWithString:model.PicUrl] placeholderImage:[UIImage imageNamed:@"holdplaceImage.png"]];
    FKV.startCityLable.text = [NSString stringWithFormat:@"%@出发",model.StartCityName];
    FKV.titleLabel.text = model.Name;
    FKV.priceLabel.text = model.PersonPrice;
    FKV.startDayLabel.text = [NSString stringWithFormat:@"最近班期:%@",model.LastScheduleDate];
    return FKV;
}

@end
