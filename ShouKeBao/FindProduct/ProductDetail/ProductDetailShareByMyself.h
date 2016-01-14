//
//  ProductDetailShareByMyself.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/6.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineShareModel.h"
#import "DefineShareViewCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "IWHttpTool.h"

//typedef enum{
//    fromQRcode,
//    fromRecommend,
//    fromStore,
//    fromProductSearch,
//    fromFindProduct,
//    fromHotProduct,
//    fromScanHistory,
//    fromZhiVisitorDynamic
//}JumpinFrom;

@protocol notiPopUpBox<NSObject>
-(void)notiPopUpBoxView;
-(void)pushChoseCustomerView:(NSString *)productJsonStr;
-(void)closeBlackView;
@end

@interface ProductDetailShareByMyself : UIView


@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *cancleBtn;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UICollectionView *collectionView;


@property (nonatomic, strong)NSDictionary *shareInfo;
@property (nonatomic, copy)NSString *URL;
@property (nonatomic, copy)NSString *fromType;
@property (nonatomic, strong)NSArray *eventArray;
@property (nonatomic,strong) NSArray *photosArr;
@property (nonatomic, strong)id publishContent;
@property (nonatomic, strong)UIView *blackView;
@property (nonatomic, strong)id<notiPopUpBox>delegate;
@property (nonatomic, copy)NSString *ProductId;

@end
