//
//  CircleHotNewsViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/11/5.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
#import "MBProgressHUD+MJ.h"
@interface CircleHotNewsViewController : SKViewController
@property (nonatomic, copy)NSString *CircleUrl;
@property (nonatomic, copy)NSString *titleName;
@property (nonatomic) NSInteger m;
@property (nonatomic, copy)NSString *formType;
@property (nonatomic, strong)UINavigationController *naV;

@end
