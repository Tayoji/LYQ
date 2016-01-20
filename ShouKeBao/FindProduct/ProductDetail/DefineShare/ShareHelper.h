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

-(void)shareSuccessWithType:(ShareType)type
               andShareInfo:(NSDictionary *)shareInfo;

@end

@interface ShareHelper : UIView
@property (nonatomic, strong)id<notiPopUpBox>delegate;

- (void)shareWithshareInfo:(NSDictionary *)shareInfo
                   andType:(/*ShareFrom*/NSString *)shareFrom
                andPageUrl:(NSString *)pageUrl;
+ (ShareHelper *)shareHelper;
@end
