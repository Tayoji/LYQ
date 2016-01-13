//
//  ZhiVisitorDynamicController.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/11.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
@class CustomModel;
typedef enum{
    VisitorDynamicTypeFromMessageCenter,
    VisitorDynamicTypeFromCustom,
}TheFromType;
@interface ZhiVisitorDynamicController : SKViewController

@property (assign, nonatomic) TheFromType visitorDynamicFromType;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)UINavigationController *NaV;
@property (nonatomic, copy) NSString * AppSkbUserId;
@property (nonatomic, copy) NSString * InvitationInfo;
@property (nonatomic, strong)CustomModel * model;
@end
