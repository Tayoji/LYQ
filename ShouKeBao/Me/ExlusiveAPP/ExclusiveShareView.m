//
//  ExclusiveShareView.m
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/17.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "ExclusiveShareView.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "MobClick.h"
#import "ExclusiveViewController.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define KHeight_Scale    [UIScreen mainScreen].bounds.size.height/480.0f
#define KHeight    [UIScreen mainScreen].bounds.size.height/667.0f
#define gap 10
@implementation ExclusiveShareView

static id _publishContent;
static id _Url;
static id _blackView;
static id _shareView;
static bool _flag;
static id _naVC;

//5 只要注册一个观察者 一定要在类的dealloc方法中 移除掉自己的观察者身份在ARC下一样
- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/

+(void)shareWithContent:(id)publishContent backgroundShareView:(id)backgroundShareView naVC:(id)naVC andUrl:(NSString *)url{
    
    _publishContent = publishContent;
    _Url = url;
    _naVC = naVC;

    NSLog(@"%f", [UIScreen mainScreen].bounds.size.height);
    UIView *shareView;
    //  自定义分享view
    if ([UIScreen mainScreen].bounds.size.height == 568) {
        shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 320)];
    }else if ([UIScreen mainScreen].bounds.size.height == 480){
        shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 280)];
    }else{
        shareView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, kScreenWidth-20, 300*KHeight)];
    }
    
    shareView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    shareView.tag = 441;
    [backgroundShareView addSubview:shareView];
    _shareView = shareView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, -15, shareView.frame.size.width-80, 40*KHeight)];
    titleLabel.layer.cornerRadius = 4;
    titleLabel.layer.masksToBounds = YES;
//    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
//    titleLabel.layer.shadowOpacity = 1.0f;
//    titleLabel.layer.shadowRadius = 2;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"恭喜您！您已开通专属APP功能";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17*KWidth_Scale];
    //    UIColor *bgcolour = [UIColor colorWithCGColor:@"ff6600"];
    //    titleLabel.backgroundColor = [UIColor colorWithCGColor:(__bridge CGColorRef)(bgcolour)];
    titleLabel.backgroundColor = [UIColor colorWithRed:252/255.0f green:102/255.0f blue:33/255.0f alpha:1];
    [shareView addSubview:titleLabel];
    
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+gap, shareView.frame.size.width-40, 50*KHeight)];
//    contentLabel.text = @"非常简单，让尽可能多的客人，安装您的专属App，立即行动，转发安装链接";
    contentLabel.text = @"专属APP能帮您随时掌握客人动态，马上行动点击下方图标，转发您的安装链接。";
    contentLabel.numberOfLines = 0;
//    contentLabel.textColor = [UIColor grayColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [shareView addSubview:contentLabel];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(contentLabel.frame)+gap, shareView.frame.size.width-20, 0.5)];
    lineV.backgroundColor = [UIColor colorWithRed:176/255.0f green:177/255.0f blue:179/255.0f alpha:1];
    [shareView addSubview:lineV];
    
    
    NSArray *btnImages = @[@"iconfont-qq", @"iconfont-pengyouquan", @"iconfont-weixin",  @"iconfont-duanxin", @"iconfont-fuzhi", @"iconfont-kongjian"];
    NSArray *btnTitles = @[@"QQ", @"朋友圈",  @"微信好友", @"短信", @"复制链接", @"QQ空间"];
    for (NSInteger i=0; i<6; i++) {
        CGFloat top = 0.0f;
        if (i<3) {
            if (KHeight > 1 || KHeight == 1) {
                top = 20*KHeight;
            }else{
                top = 30*KHeight;
            }
        }else{
            if (KHeight > 1 || KHeight == 1) {
                top = 105*KHeight;
            }else{
                 top = 140*KHeight;
            }
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30*KWidth_Scale+(i%3)*100*KWidth_Scale, CGRectGetMidY(lineV.frame)+top, 80*KWidth_Scale, 80*KWidth_Scale)];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        if (i == 1) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 20*KWidth_Scale, 15*KWidth_Scale, 8*KWidth_Scale)];
        }else{
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 20*KWidth_Scale, 15*KWidth_Scale, 8*KWidth_Scale)];
        }
        
        if (KHeight > 1) {
             [button setTitleEdgeInsets:UIEdgeInsetsMake(53*KWidth_Scale, -42*KWidth_Scale, 10*KWidth_Scale, 0)];
        }else{
             [button setTitleEdgeInsets:UIEdgeInsetsMake(60*KWidth_Scale, -47*KWidth_Scale, 10*KWidth_Scale, 0)];
        }
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
    
  
//    UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareView.frame)-30, shareView.frame.size.width, 40)];
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

+(void)shareBtnClick:(UIButton *)btn{
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 331:
        {
            shareType = ShareTypeQQ;
        }
            break;
            
        case 332:
        {
            shareType =  ShareTypeWeixiTimeline;
        }
            break;
            
        case 333:
        {
            shareType =  ShareTypeWeixiSession;
        }
            break;
            
        case 334:
        {
            shareType = ShareTypeSMS;
        }
            break;
            
        case 335:
        {
            shareType = ShareTypeCopy;
        }
            break;
            
        case 336:
        {
            shareType = ShareTypeQQSpace;
        }
            break;
            
        default:
            break;
            
    }
    /*
     调用shareSDK的无UI分享类型 */
    
    [ShareSDK showShareViewWithType:shareType container:[ShareSDK container] content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        NSLog(@"..... %@", publishContent);
        
        if (state == SSResponseStateSuccess){
            
            if (type ==ShareTypeWeixiSession) {

            }else if(type == ShareTypeQQ){

            }else if(type == ShareTypeQQSpace){

            }else if(type == ShareTypeWeixiTimeline){

            }
            
            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
            if (type == ShareTypeCopy) {
                [MBProgressHUD showSuccess:@"复制成功"];
            }else{
                [MBProgressHUD showSuccess:@"分享成功"];
                
                ExclusiveViewController *exclusiveVC = [[ExclusiveViewController alloc]init];
                [_naVC pushViewController:exclusiveVC animated:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                [MBProgressHUD hideHUD];
            });
         
        }else if (state == SSResponseStateFail){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error errorDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
}






@end
