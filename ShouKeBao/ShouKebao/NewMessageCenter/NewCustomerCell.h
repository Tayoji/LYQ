//
//  NewCustomerCell.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/12.
//  Copyright © 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomDynamicModel;
@class VisitorDynamicProductView;
@interface NewCustomerCell : UITableViewCell
@property (nonatomic, strong)UINavigationController * NAV;

@property (strong, nonatomic) IBOutlet UIImageView *TitleImage;//动态类型图片
@property (strong, nonatomic) IBOutlet UILabel *UserName;//客户的名称
@property (strong, nonatomic) IBOutlet UILabel *WXName;//客户的微信昵称

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;//消息时间
@property (strong, nonatomic) IBOutlet UILabel *MessageLab;//消息的内容
@property (strong, nonatomic) IBOutlet UIButton *MessageButton;

@property (nonatomic, strong)VisitorDynamicProductView * ProductView;//自定义的一个产品详情视图，根据类型判断是否展示

@property (nonatomic, strong)CustomDynamicModel * model;
@end
