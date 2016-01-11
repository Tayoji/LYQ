//
//  FKSendRedPacketView.m
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/11.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "FKSendRedPacketView.h"

@implementation FKSendRedPacketView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViewsWithFrame:frame];
    }
    return self;
}
- (void)setUpSubViewsWithFrame:(CGRect)frame{//237 253 73
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 90)];
    backgroundView.backgroundColor = [UIColor colorWithRed:237/255.0 green:153/255.0 blue:73/255.0 alpha:1.0];
    [self addSubview:backgroundView];
    
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 54, 60)];
    iconView.image = [UIImage imageNamed:@"holdplaceImage"];
    [backgroundView addSubview:iconView];
    
    UILabel * upLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+10, CGRectGetMinY(iconView.frame)+3, frame.size.width - CGRectGetMaxX(iconView.frame)-15, 20)];
    upLab.textColor = [UIColor whiteColor];
    upLab.font = [UIFont systemFontOfSize:16];
    upLab.text = @"先领红包，再出游！";
    [backgroundView addSubview:upLab];
    
    UILabel * downLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+10, CGRectGetMaxY(iconView.frame)-23, frame.size.width - CGRectGetMaxX(iconView.frame)-15, 20)];
    downLab.textColor = [UIColor whiteColor];
    downLab.font = [UIFont boldSystemFontOfSize:16];
    downLab.text = @"查看红包";
    [backgroundView addSubview:downLab];
    
    UILabel * bottomLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backgroundView.frame), frame.size.width, 30)];
    bottomLab.backgroundColor = [UIColor whiteColor];
    bottomLab.font = [UIFont systemFontOfSize:16];
    bottomLab.textColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    bottomLab.text = @"  旅游顾问红包";
    [self addSubview:bottomLab];
    
    UIImageView * littleIconImage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 23, CGRectGetMaxY(backgroundView.frame)+5, 20, 20)];
    littleIconImage.image= [UIImage imageNamed:@"holdplaceImage"];
    littleIconImage.layer.cornerRadius = 3;
    littleIconImage.layer.masksToBounds = YES;
    [self addSubview:littleIconImage];
    
}


+ (FKSendRedPacketView *)FKSendRedPacketWithModel:(MessageModel *)model
                                         andFrame:(CGRect)frame{
    FKSendRedPacketView * FKV = [[FKSendRedPacketView alloc]initWithFrame:frame];
    return FKV;
}

@end
