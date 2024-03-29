//
//  OrderDetailViewController.h
//  ShouKeBao
//
//  Created by 金超凡 on 15/3/27.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface ButtonDetailViewController : SKViewController

@property (nonatomic,copy) NSString *linkUrl;
@property (nonatomic, assign)BOOL isWriteVisitorsInfo;
@property (nonatomic, strong)NSDictionary * userInfoDic;
@property (nonatomic, strong)NSMutableDictionary * shareInfo;


- (void)postCustomerToServer:(NSArray * )customerIDs;
- (void)postPicToServer:(NSArray *)PicArray;
- (void)postContractPicToServer:(NSArray *)PicArray;
@end
