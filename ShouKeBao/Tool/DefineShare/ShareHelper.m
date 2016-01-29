//
//  ShareHelper.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/15.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ShareHelper.h"
#import "DefineShareModel.h"
#import "DefineShareViewCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"

#define kScreenWidth   self.shareView.frame.size.width
#define kScreenHeight  self.shareView.frame.size.height
#define gap 10
static NSString * cellid = @"reuseaa";

@interface ShareHelper()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSDictionary *shareInfo;
@property (nonatomic, copy)NSString *URL;
@property (nonatomic, copy)NSString *fromType;
@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, strong)id publishContent;
@property (nonatomic, strong)UIView *exclusiveV;
@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *cancleBtn;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIView *blackView;

@end


@implementation ShareHelper
+ (ShareHelper *)shareHelper{
    static ShareHelper * shareH = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareH = [[ShareHelper alloc] init];
        if ([UIScreen mainScreen].bounds.size.height == 480) {
             shareH.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/4, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*3/4);
        }else{
           shareH.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/3, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/3);
        }
        
        });
    return shareH;
}


- (void)shareWithshareInfo:(NSDictionary *)shareInfo
                   andType:(/*ShareFrom*/NSString *)shareFrom
                andPageUrl:(NSString *)pageUrl{
    _shareInfo = shareInfo;
    _URL = pageUrl;
    _fromType = shareFrom;
//    布局
    [self setLayout];
    [self setExclusiveBox];
    self.hidden = NO;
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareInfo[@"Desc"]
                                       defaultContent:shareInfo[@"Desc"]
                                                image:[ShareSDK imageWithUrl:shareInfo[@"Pic"]]
                                                title:shareInfo[@"Title"]
                                                  url:shareInfo[@"Url"]                                           description:shareInfo[@"Desc"]
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addCopyUnitWithContent:[NSString stringWithFormat:@"%@",shareInfo[@"Url"]] image:nil];
    NSLog(@"%@444", shareInfo);
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"%@", shareInfo[@"Url"]]];
    _publishContent = publishContent;
}
- (void)setLayout{
    NSString *IMProductMsgValue = [NSString stringWithFormat:@"%@",  self.shareInfo[@"IMProductMsgValue"]];
    
    NSLog(@"..%@. %@ %ld/// %@", self.shareInfo, IMProductMsgValue, IMProductMsgValue.length, self.shareInfo[@"IMProductMsgValue"]);

    if (/*IMProductMsgValue.length && ![IMProductMsgValue isEqualToString:@""]![IMProductMsgValue isKindOfClass:[NSNull class]] ||*/ IMProductMsgValue.length &&![IMProductMsgValue isEqualToString:@"(null)"]) {
        self.photosArr = @[@{@"pic":@"iconfont-weixin", @"title":@"微信好友"},
                           @{@"pic":@"iconfont-pengyouquan", @"title":@"微信朋友圈"},
                           @{@"pic":@"exclusiveUser", @"title":@"专属客人"},
                           @{@"pic":@"collectP", @"title":@"微信收藏"},
                           @{@"pic":@"iconfont-qq", @"title":@"QQ"},
                           @{@"pic":@"iconfont-duanxin", @"title":@"短信"},
                           @{@"pic":@"iconfont-fuzhi", @"title":@"复制链接"}
                           ];
    }else{
        self.photosArr = @[@{@"pic":@"iconfont-weixin", @"title":@"微信好友"},
                           @{@"pic":@"iconfont-pengyouquan", @"title":@"微信朋友圈"},
                           @{@"pic":@"iconfont-kongjian", @"title":@"QQ空间"},
                           @{@"pic":@"collectP", @"title":@"微信收藏"},
                           @{@"pic":@"iconfont-qq", @"title":@"QQ"},
                           @{@"pic":@"iconfont-duanxin", @"title":@"短信"},
                           @{@"pic":@"iconfont-fuzhi", @"title":@"复制链接"}
                           ];
    }
    
    
    
    //阴影
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    blackView.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:blackView];
    self.blackView = blackView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleBtnClickAction)];
    [self.blackView addGestureRecognizer:tap];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareView];
    self.shareView = shareView;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    titleLabel.text = @"分享";
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:25];
    [shareView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth*4/5-10, 10, kScreenWidth/5, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.layer.borderWidth = 1.0;
    cancleBtn.layer.cornerRadius = 4;
    cancleBtn.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    [cancleBtn setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    self.cancleBtn = cancleBtn;
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), kScreenWidth, 30)];
    contentLabel.text = @"您分享出去的内容对外只显示门市价";
    contentLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:12];
    [shareView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(contentLabel.frame)+gap, kScreenWidth-60, self.frame.size.height-(CGRectGetMaxY(contentLabel.frame)+gap)-gap) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[DefineShareViewCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    [shareView addSubview:collectionView];
    self.collectionView = collectionView;
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

#pragma mark -UICollectionView 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DefineShareViewCollectionViewCell *defineCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    DefineShareModel *defineShareModel = self.photosArr[indexPath.row];
    defineCell.model = defineShareModel;
    return defineCell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     CGFloat screenW = collectionView.bounds.size.width;
    CGFloat superiMGW = screenW-2*gap;
    CGFloat imgW = superiMGW/3;
    return CGSizeMake(imgW, imgW);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int shareType = 0;
    id publishContent = self.publishContent;
    switch (indexPath.row) {
        case 0:{
            shareType =  ShareTypeWeixiSession;
        }
            break;
        case 1:{
            shareType = ShareTypeWeixiTimeline;
        }
            break;
        case 2:{
            
            NSString *IMProductMsgValueStr = [NSString stringWithFormat:@"%@", self.shareInfo[@"IMProductMsgValue"]];
            
            if (IMProductMsgValueStr.length && ![IMProductMsgValueStr isEqualToString:@"(null)"]) {
                 shareType = ShareTypeOther;
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LVGWIsOpenVIP"] isEqualToString:@"0"]) {
                    self.hidden = YES;
                    self.blackView.hidden = NO;
                    self.exclusiveV.hidden = NO;
                    
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LVGWIsOpenVIP"] isEqualToString:@"1"]){
                    if (_delegate && [_delegate respondsToSelector:@selector(pushChoseCustomerView:)]) {
                        [self cancleBtnClickAction];
                        [_delegate pushChoseCustomerView:self.shareInfo[@"IMProductMsgValue"]];
                    }
                }
            }else{
                shareType = ShareTypeQQSpace;
            }
        }
            break;
        case 3:{
            shareType =  ShareTypeWeixiFav;
        }
            break;
        case 4:{
            shareType = ShareTypeQQ;
        }
            break;
        case 5:{
            shareType = ShareTypeSMS;
        }
            break;
        case 6:{
            shareType = ShareTypeCopy;
        }
            break;
        default:
            break;
    }
    [ShareSDK showShareViewWithType:shareType container:[ShareSDK container] content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        

        if (state == SSResponseStateSuccess){
            
            if (_delegate&&[_delegate respondsToSelector:@selector(shareSuccessWithType:andShareInfo:)]) {
                [_delegate shareSuccessWithType:shareType andShareInfo:self.shareInfo];
            }
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShareSuccessAll" attributes:dict];
            [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
            [MobClick event:@"ProductDetailShareSuccessClickAll" attributes:dict];
            
            if ([self.fromType isEqualToString:@"FromFindProduct"] || [self.fromType isEqualToString:@"FromHotProduct"] || [self.fromType isEqualToString:@"FromProductSearch"] || [self.fromType isEqualToString:@"FromZhiVisitorDynamic"]) {
                [MobClick event:@"FromFindProductAllShareSuccess" attributes:dict];
            }
            if ([self.fromType isEqualToString:@"FromRecommend"]) {
                [MobClick event:@"RecommendShareSuccessAll" attributes:dict];
                
            }
            [MobClick event:[NSString stringWithFormat:@"%@ShareSuccess", self.fromType] attributes:dict];
            
//          今日推荐
            if ([self.fromType isEqualToString:@"RecommendShareSuccessAndAllJS"]) {
                [MobClick event:@"RecommendShareSuccess" attributes:dict];
                [MobClick event:@"ShareSuccessAll" attributes:dict];
                [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
                [MobClick event:@"RecommendShareSuccessAll" attributes:dict];

            }
            
//          店铺详情
            if ([self.fromType isEqualToString:@"ShouKeBaoStoreShareSuccess"]) {
                [MobClick event:@"ShouKeBaoStoreShareSuccess" attributes:dict];
                [MobClick event:@"ShouKeBaoStoreShareSuccessJS" attributes:dict counter:3];
                [MobClick event:@"ShareSuccessAll" attributes:dict];
                [MobClick event:@"ShareSuccessAllJS" attributes:dict counter:3];
            }
//            专属App数据分享
            if ([self.fromType isEqualToString:@"Me_exclusiveAppShareScccessCount"]) {
                [MobClick event:@"Me_exclusiveAppShareScccessCount" attributes:dict];
            }
            
            NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
            [postDic setObject:@"0" forKey:@"ShareType"];
            if (self.shareInfo[@"Url"]) {
                [postDic setObject:self.shareInfo[@"Url"]  forKey:@"ShareUrl"];
            }
            [postDic setObject:/*self.webView.request.URL.absoluteString */ self.URL forKey:@"PageUrl"];
            
            if (type ==ShareTypeWeixiSession) {
                [postDic setObject:@"1" forKey:@"ShareWay"];
            }else if(type == ShareTypeQQ){
                [postDic setObject:@"2" forKey:@"ShareWay"];
            }else if(type == ShareTypeQQSpace){
                [postDic setObject:@"3" forKey:@"ShareWay"];
            }else if(type == ShareTypeWeixiTimeline){
                [postDic setObject:@"4" forKey:@"ShareWay"];
            }
            
            [IWHttpTool postWithURL:@"Common/SaveShareRecord" params:postDic success:^(id json) {
                NSDictionary * dci = json;
                NSMutableString * string = [NSMutableString string];
                for (id str in dci.allValues) {
                    [string appendString:str];
                }
            } failure:^(NSError *error) {
                
            }];
            //产品详情
            if (type == ShareTypeCopy) {
                [MBProgressHUD showSuccess:@"复制成功"];
            }else{
                [MBProgressHUD showSuccess:@"分享成功"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 2.0s后执行block里面的代码
                [MBProgressHUD hideHUD];
            });
        }else if (state == SSResponseStateFail){
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShareFailAll" attributes:dict];
            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error errorDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else if (state == SSResponseStateCancel){
            
        }
    }];

}

//自定义弹出框走开通专属app界面
- (void)setExclusiveBox{
    if ([UIScreen mainScreen].bounds.size.height>568) {
        self.exclusiveV = [[UIView alloc]initWithFrame:CGRectMake(30, 200, [UIScreen mainScreen].bounds.size.width-60, 200)];
    }else{
        self.exclusiveV = [[UIView alloc]initWithFrame:CGRectMake(10, 200, [UIScreen mainScreen].bounds.size.width-20, 200)];
    }
    self.exclusiveV.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self.exclusiveV];
     self.exclusiveV.layer.masksToBounds = YES;
    self.exclusiveV.hidden = YES;
     self.exclusiveV.layer.cornerRadius = 10;
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.exclusiveV.frame.size.width, 50)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"boxBackg1"];
    [self.exclusiveV addSubview:imageV];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(imageV.frame.size.width-50, 0, 50, 50);
    [button setImage:[UIImage imageNamed:@"iconfont-cancle"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancleBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:button];
    
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame), self.exclusiveV.frame.size.width, 80)];
    tipL.text = @"开通专属APP，才能使用此功能!";
    tipL.textAlignment = NSTextAlignmentCenter;
    tipL.font = [UIFont systemFontOfSize:19.0f];
    [self.exclusiveV addSubview:tipL];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([UIScreen mainScreen].bounds.size.height>568) {
        button1.frame = CGRectMake(80, CGRectGetMaxY(tipL.frame)+10, self.exclusiveV.frame.size.width-160, 40);
    }else{
        button1.frame = CGRectMake(70, CGRectGetMaxY(tipL.frame)+10, self.exclusiveV.frame.size.width-140, 40);
    }
    
    [button1 setTitle:@"立即申请开通" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button1.layer.borderColor = [UIColor orangeColor].CGColor;
    button1.layer.borderWidth = 1.0f;
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 20.0f;
    [button1 addTarget:self action:@selector(pushApplyForOpenVip) forControlEvents:UIControlEventTouchUpInside];
    [self.exclusiveV addSubview:button1];
}

- (void)pushApplyForOpenVip{
    if (_delegate && [_delegate respondsToSelector:@selector(notiPopUpBoxView)]) {
        [self cancleBtnClickAction];
        [_delegate notiPopUpBoxView];
    }
}
- (void)cancleBtnClickAction{
    self.blackView.hidden = YES;
    self.exclusiveV.hidden = YES;
    self.hidden = YES;
}

- (NSArray *)photosArr{
    if (!_photosArr) {
        self.photosArr = [NSArray array];
    }
    return _photosArr;
}
-(NSDictionary *)shareInfo{
    if (!_shareInfo) {
        _shareInfo = [NSDictionary dictionary];
    }
    return _shareInfo;
}
@end
