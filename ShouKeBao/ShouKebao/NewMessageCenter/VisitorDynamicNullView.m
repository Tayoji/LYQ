//
//  VisitorDynamicNullView.m
//  ShouKeBao
//
//  Created by 冯坤 on 16/1/7.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "VisitorDynamicNullView.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ImageX ScreenW/4.0
#define ImageY 40
#define ImageW ScreenW/2.0

#define Image2X ScreenW/3.0
#define Image2W ScreenW/3.0


@interface VisitorDynamicNullView ()
@property (nonatomic, strong)UIImageView * nullImage;
@property (nonatomic, strong)UILabel * upLab;
@property (nonatomic, strong)UILabel * downLab;
@property (nonatomic, strong)UIButton * theBtn;
@end

@implementation VisitorDynamicNullView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setInviteVistorView{
    self.nullImage = [[UIImageView alloc]init];
    self.nullImage.image = [UIImage imageNamed:@"content_null"];
    [self addSubview:self.nullImage];
    
    self.upLab = [[UILabel alloc]init];
    self.upLab.text = @"TA还不是您的专属APP客人，无法查看TA的动态！";
    self.upLab.font = [UIFont systemFontOfSize:15];
    self.upLab.textAlignment = NSTextAlignmentCenter;
    self.upLab.numberOfLines = 0;
    self.upLab.textColor = [UIColor blackColor];

    [self addSubview:self.upLab];
    
   self.downLab = [[UILabel alloc]init];
    self.downLab.numberOfLines = 0;
    self.downLab.textColor = [UIColor lightGrayColor];
    self.downLab.text = @"马上向TA发送邀请成为您的专属客户，实时掌握TA的动态！";
    self.downLab.font = [UIFont systemFontOfSize:15];
    self.downLab.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.downLab];
    
    
    self.theBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.theBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [self.theBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theBtn.layer.masksToBounds = YES;
    self.theBtn.layer.cornerRadius = 5;
    [self addSubview:self.theBtn];
    
    
}
//邀请
- (void)InviteClick{
    if ([self.delegate respondsToSelector:@selector(ClickInviteVisitor)]) {
        [self.delegate ClickInviteVisitor];
        
    }
}
//发红包
- (void)SendRedPacket{
    if ([self.delegate respondsToSelector:@selector(ClickSendRedPacket)]) {
        [self.delegate ClickSendRedPacket];
    }
}

- (void)showNullViewToView:(UIView *)View Type:(NullType)nullType{
    self.frame = View.bounds;
    [self setInviteVistorView];
    if (nullType == nullTyeInviteVisitor) {
        self.nullImage.frame = CGRectMake(Image2X, ImageY, Image2W, Image2W);
        self.upLab.frame = CGRectMake(ImageX, CGRectGetMaxY(self.nullImage.frame)+30, ImageW, 50);
        self.downLab.frame = CGRectMake(ScreenW/5.0, CGRectGetMaxY(self.upLab.frame), ScreenW*3/5.0, 50);
        
        
        [self.theBtn addTarget:self action:@selector(InviteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.theBtn setBackgroundColor:[UIColor colorWithRed:251/255.0 green:178/255.0 blue:63/255.0 alpha:1.0]];
        [self.theBtn setTitle:@"邀请" forState:UIControlStateNormal];
        self.theBtn.frame = CGRectMake(0, 0, 170, 45);
        
        
        
        
        self.nullImage.image = [UIImage imageNamed:@"content_null2"];
        self.upLab.text = @"TA还不是您的专属APP客人，无法查看TA的动态！";
        self.downLab.text = @"马上向TA发送邀请成为您的专属客户，实时掌握TA的动态！";


    }else if(nullType == nullTypeSendRedPacket){
        self.nullImage.frame = CGRectMake(ImageX, ImageY, ImageW, ImageW*5/4.0);
        self.upLab.frame = CGRectMake(ImageX, CGRectGetMaxY(self.nullImage.frame), ImageW, 50);
        self.downLab.frame = CGRectMake(ScreenW/5.0, CGRectGetMaxY(self.upLab.frame), ScreenW*3/5.0, 50);

        [self.theBtn addTarget:self action:@selector(SendRedPacket) forControlEvents:UIControlEventTouchUpInside];
        [self.theBtn setBackgroundColor:[UIColor colorWithRed:209/255.0 green:88/255.0 blue:73/255.0 alpha:1]];
        [self.theBtn setTitle:@"发红包" forState:UIControlStateNormal];
        self.theBtn.frame = CGRectMake(0, 0, 150, 45);

        
        
        
        self.nullImage.image = [UIImage imageNamed:@"content_null"];
        self.upLab.text = @"该客人暂无动态！";
        self.downLab.text = @"赶快给TA发个红包表示诚意吧！";

    }
    self.theBtn.center = CGPointMake(ScreenW/2.0, CGRectGetMaxY(self.downLab.frame)+40);
}






- (void)hideNullViewFromView:(UIView *)View{
    [self removeFromSuperview];
}
@end
