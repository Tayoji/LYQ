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
//    FromQRcode,
//    FromRecommend,
//    FromStore,
//    FromProductSearch,
//    FromFindProduct,
//    FromHotProduct,
//    FromScanHistory,
//    FromZhiVisitorDynamic
//}JumpinFrom;

@interface ProductDetailShareByMyself : UIView


@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *cancleBtn;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UICollectionView *collectionView;


@property (nonatomic, strong)NSDictionary *shareInfo;
@property (nonatomic, copy)NSString *URL;
//@property (nonatomic, assign)JumpinFrom fromType;
@property (nonatomic, strong)NSArray *eventArray;
@property (nonatomic, strong)id publishContent;
@property (nonatomic, strong)UIView *blackView;

//+(void)shareWithContent:(id)publishContent andUrl:(NSString *)url eventArray:(NSArray *)eventArray shareInfo:(NSDictionary *)shareInfo ;
@end
