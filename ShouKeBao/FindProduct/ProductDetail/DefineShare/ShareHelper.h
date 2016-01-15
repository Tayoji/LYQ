//
//  ShareHelper.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/15.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@protocol notiPopUpBox<NSObject>
-(void)notiPopUpBoxView;
-(void)pushChoseCustomerView:(NSString *)productJsonStr;
-(void)closeBlackView;
@end

typedef enum{
    FromQRcode1,
    FromRecommend1,
    FromStore1,
    FromProductSearch1,
    FromFindProduct1,
    FromHotProduct1,
    FromScanHistory1,
    FromZhiVisitorDynamic1
}ShareFrom;

@interface ShareHelper : UIView
//将分享内容和分享类型传进来， SharePushFrom 用于区分不同页面的不同分享
- (void)shareWithshareInfo:(NSDictionary *)shareInfo
                   andType:(ShareFrom)shareFrom
                andPageUrl:(NSString *)pageUrl;

//分享单例
+ (ShareHelper *)shareHelper;
//- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *cancleBtn;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UICollectionView *collectionView;


@property (nonatomic, strong)NSDictionary *shareInfo;
@property (nonatomic, copy)NSString *URL;
@property (nonatomic, assign)ShareFrom fromType;
//@property (nonatomic, strong)NSArray *eventArray;
@property (nonatomic,strong) NSArray *photosArr;
@property (nonatomic, strong)id publishContent;
//@property (nonatomic, strong)UIView *blackView;
@property (nonatomic, strong)id<notiPopUpBox>delegate;
//@property (nonatomic, copy)NSString *ProductId;


@end
