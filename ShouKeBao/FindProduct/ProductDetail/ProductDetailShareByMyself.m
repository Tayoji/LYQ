//
//  ProductDetailShareByMyself.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/6.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ProductDetailShareByMyself.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"

#define kScreenWidth   self.shareView.frame.size.width
#define kScreenHeight  self.shareView.frame.size.height
#define gap 10
static NSString * cellid = @"reuseaa";


@interface ProductDetailShareByMyself()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>



@end

@implementation ProductDetailShareByMyself

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
        self.photosArr = [NSArray array];
     
        
//        if (self.shareInfo[@"ProductId"]) {
//        self.photosArr = @[@{@"pic":@"iconfont-weixin", @"title":@"微信好友"},
//                           @{@"pic":@"iconfont-pengyouquan", @"title":@"微信朋友圈"},
//                           @{@"pic":@"exclusiveUser", @"title":@"专属客人"},
//                           @{@"pic":@"iconfont-fuzhi", @"title":@"微信收藏"},
//                           @{@"pic":@"iconfont-qq", @"title":@"QQ"},
////                           @{@"pic":@"iconfont-kongjian", @"title":@"QQ空间"},
//                           @{@"pic":@"iconfont-duanxin", @"title":@"短信"},
//                           @{@"pic":@"iconfont-fuzhi", @"title":@"复制链接"}
//                           ];
//        }else{
//            self.photosArr = @[@{@"pic":@"iconfont-weixin", @"title":@"微信好友"},
//                               @{@"pic":@"iconfont-pengyouquan", @"title":@"微信朋友圈"},
//                               @{@"pic":@"iconfont-kongjian", @"title":@"QQ空间"},
//                               @{@"pic":@"iconfont-fuzhi", @"title":@"微信收藏"},
//                               @{@"pic":@"iconfont-qq", @"title":@"QQ"},
//                               @{@"pic":@"iconfont-duanxin", @"title":@"短信"},
//                               @{@"pic":@"iconfont-fuzhi", @"title":@"复制链接"}
//                               ];
//   
//            
//        }

    }
    return self;
}


- (void)setLayout{

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
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(contentLabel.frame)+gap, kScreenWidth-40, self.frame.size.height-(CGRectGetMaxY(contentLabel.frame)+gap)-gap) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[DefineShareViewCollectionViewCell class] forCellWithReuseIdentifier:cellid];
    [shareView addSubview:collectionView];
    self.collectionView = collectionView;
   
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DefineShareViewCollectionViewCell *defineCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    DefineShareModel *defineShareModel = self.photosArr[indexPath.row];
    defineCell.model = defineShareModel;
    return defineCell;
    
}

//item的大小
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
    
    NSLog(@"....self.publishContent = %@............", self.publishContent);
  
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
                if (self.shareInfo[@"ProductId"]) {
                    shareType = ShareTypeOther;
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LVGWIsOpenVIP"] isEqualToString:@"0"]) {
                        if (_delegate && [_delegate respondsToSelector:@selector(notiPopUpBoxView)]) {
                            [_delegate notiPopUpBoxView];
                        }
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LVGWIsOpenVIP"] isEqualToString:@"1"]){
                        if (_delegate && [_delegate respondsToSelector:@selector(pushChoseCustomerView:)]) {
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
            
            NSLog(@"..... %@", publishContent);
            
            if (state == SSResponseStateSuccess){
                
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
                [MobClick event:[NSString stringWithFormat:@"%@ShareSuccess", [self.eventArray objectAtIndex:[self.fromType integerValue]]] attributes:dict];
                
                //精品推荐填1
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

- (void)cancleBtnClickAction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(closeBlackView)]) {
        [_delegate closeBlackView];
    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
