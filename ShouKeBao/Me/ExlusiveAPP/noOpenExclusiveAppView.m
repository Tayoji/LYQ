//
//  noOpenExclusiveAppView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/18.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "noOpenExclusiveAppView.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "UserInfo.h"
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define KHeight    [UIScreen mainScreen].bounds.size.height/667.0f

@implementation noOpenExclusiveAppView

static id _Tel;
static id _shareView;


+(void)backgroundShareView:(id)backgroundShareView andUrl:(NSString *)url{
    _Tel = url;
    
    NSLog(@"%f", kScreenHeight);
    //  自定义弹出的分享view
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 150)];
    shareView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    shareView.tag = 441;
    [backgroundShareView addSubview:shareView];
    _shareView = shareView;
    
   // UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, -10, shareView.frame.size.width-180, 25*KHeight)];
   // titleLabel.backgroundColor = [UIColor colorWithRed:251/255.0f green:78/255.0f blue:10/255.0f alpha:1];
   // titleLabel.textColor = [UIColor whiteColor];
   // titleLabel.text = @"怎么享受这些好处？";
   // titleLabel.layer.masksToBounds = YES;
   // titleLabel.layer.cornerRadius = 2;
   // titleLabel.textAlignment = NSTextAlignmentCenter;
   // titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
   // [shareView addSubview:titleLabel];
    
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*KHeight, /*CGRectGetMaxY(titleLabel.frame)*/15, shareView.frame.size.width-40, 50*KHeight)];
//    contentLabel.text = @"非常简单，让尽可能多的客人，安装您的专属App";
    contentLabel.text = @"未达到等级的顾问联系客户经理获取限量名额，赶紧抢！";
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:contentLabel];
    
    
//    UILabel *rContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contentLabel.frame)+10, shareView.frame.size.width-40, 50*KHeight)];
//    rContentLabel.text = @"不够银级，马上找您的客户经理勾兑一下！";
//    rContentLabel.numberOfLines = 0;
//    rContentLabel.textColor = [UIColor orangeColor];
//    rContentLabel.textAlignment = NSTextAlignmentCenter;
//    rContentLabel.font = [UIFont systemFontOfSize:12];
//    [shareView addSubview:rContentLabel];
    
    
    UIButton *contactB = [UIButton buttonWithType:UIButtonTypeCustom];
    contactB.frame = CGRectMake(40, CGRectGetMaxY(contentLabel.frame), shareView.frame.size.width-80, 50*KHeight);
    [shareView addSubview:contactB];
    contactB.backgroundColor = [UIColor colorWithRed:249/255.0f green:79/255.0f blue:9/255.0f alpha:1];
    [contactB setTitle:@"立即联系客户经理" forState:UIControlStateNormal];
    contactB.layer.masksToBounds = YES;
    contactB.layer.cornerRadius = 3;
    [contactB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contactB addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    
    
        UILabel *rContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contactB.frame), shareView.frame.size.width-40, 20)];
        rContentLabel.text = @"(开通即领取1000现金劵)";
        rContentLabel.numberOfLines = 0;
        rContentLabel.textColor = [UIColor orangeColor];
        rContentLabel.textAlignment = NSTextAlignmentCenter;
        rContentLabel.font = [UIFont systemFontOfSize:12];
        [shareView addSubview:rContentLabel];
    
//    UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareView.frame)-40, shareView.frame.size.width, 40)];
//    downImage.image = [UIImage imageNamed:@"downImage"];
//    [shareView addSubview:downImage];
    
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareView.frame)-15, 40, 40)];
    lable1.text = @"让您在";
    lable1.font = [UIFont systemFontOfSize:13.0f];
    [shareView addSubview:lable1];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable1.frame), CGRectGetMaxY(shareView.frame)-15+10, 15, 15)];
    image1.image = [UIImage imageNamed:@"gou"];
    [shareView addSubview:image1];
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame), CGRectGetMaxY(shareView.frame)-15, 55, 40)];
    lable2.text = @"任何时间";
    lable2.font = [UIFont systemFontOfSize:13.0f];
    [shareView addSubview:lable2];
    
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable2.frame), CGRectGetMaxY(shareView.frame)-15+10, 15, 15)];
    image2.image = [UIImage imageNamed:@"gou"];
    [shareView addSubview:image2];
    
    UILabel *lable3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame), CGRectGetMaxY(shareView.frame)-15, shareView.frame.size.width-CGRectGetMaxX(image2.frame), 40)];
    lable3.text = @"任何地点 为客人提供专属服务";
    lable3.font = [UIFont systemFontOfSize:13.0f];
    [shareView addSubview:lable3];
    
    
    
}


+ (void)callPhone{
    
    BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
    [MobClick event:@"Me_contactManagerImmediatelyClick" attributes:dict];
    
    NSString *mobile = [UserInfo shareUser].sosMobile;
    NSString *phone = [NSString stringWithFormat:@"tel://%@",mobile];
    NSLog(@"----------------手机号码%@------------------",phone);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
