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



@end

@interface ShareHelper : UIView
@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *cancleBtn;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIView *blackView;
@property (nonatomic, strong)id<notiPopUpBox>delegate;

- (void)shareWithshareInfo:(NSDictionary *)shareInfo
                   andType:(/*ShareFrom*/NSString *)shareFrom
                andPageUrl:(NSString *)pageUrl;
+ (ShareHelper *)shareHelper;
@end
