//
//  OrderModel.m
//  ShouKeBao
//
//  Created by Chard on 15/3/24.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "OrderModel.h"
#import "ButtonList.h"
#import "UIColor+SK.h"
#import "NSMutableDictionary+QD.h"
@implementation OrderModel

+ (instancetype)orderModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSMutableDictionary * dic = [NSMutableDictionary cleanNullResult:dict];
        self.ProgressState = dic[@"ProgressState"];// 进度
        
        self.StateText = dic[@"StateText"];// 状态文字
        
        self.ProductPicUrl = dic[@"ProductPicUrl"];// 旅游图标
        
        // 状态文字颜色
        self.StateTextColor = [UIColor configureColorWithNum:[dic[@"StateTextColor"] integerValue]];
        
        // 上线条颜色
        self.TopBarColor = [UIColor configureColorWithNum:[dic[@"TopBarColor"] integerValue]];
        
        self.ProductName = dic[@"ProductName"];// 旅游标题
        
        self.OrderPrice = dic[@"OrderPrice"];// 价格
        
        self.IsCruiseShip = dic[@"IsCruiseShip"];// 是否游轮 是就显示 成人 + 小孩 (人数)
        
        self.PersonCount = dic[@"PersonCount"];// 成人数
        
        self.ChildCount = dic[@"ChildCount"];// 小孩数
        
        self.CreatedDate = dic[@"CreatedDate"];// 创建时间
        
        self.GoDate = dic[@"GoDate"];// 出发时间
        self.FromOrder = dic[@"FromOrder"];//显示标示
        self.Code = dic[@"Code"];// 订单编号
        
        self.DetailLinkUrl = dic[@"DetailLinkUrl"];
        
        if (![dic[@"SKBOrder"] isKindOfClass:[NSNull class]]) {
            self.SKBOrder = dic[@"SKBOrder"];
        }
        
        self.FollowPerson = dic[@"FollowPerson"];
        
        //获取OrderId用于再次请求后台数据；
        self.OrderId = dic[@"OrderId"];
#warning 1.4版本用法
        // 返回底部按钮组
//        for (NSDictionary *dic2 in dic[@"ButtonList"]) {
//            ButtonList *btn = [ButtonList buttonListWithDict:dic2];
//            [self.buttonList addObject:btn];
//        }
  

#warning 分类显示
        NSMutableArray *arr = dic[@"ButtonList"];
        for (int i = 0; i < arr.count; i++) {
            
            ButtonList *btn = [ButtonList buttonListWithDict:arr[i]];
             if (arr.count<3) {//1 2的时候
                [self.buttonList addObject:btn];
            }else{//多于等于3个的时候
                if ((int)btn.color == 3) {
                     [self.buttonList addObject:btn];
                }else{
                    [self.btnList addObject:btn];
                }
                [self.buttonList insertObject:self.btnList[0] atIndex:1];
                [self.btnList removeObjectAtIndex:0];
            }
        }
            if (self.btnList.count) {
               [self.buttonList addObject:self.btnList];//将二级实现放在数组里作为一个元素
        }
    }
    return self;
}

- (NSString *)Code{
    return [NSString stringWithFormat:@"订单号:%@",_Code];
}

- (NSString *)GoDate
{
    return [NSString stringWithFormat:@"%@出发",_GoDate];
}

- (NSMutableArray *)buttonList
{
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}
- (NSMutableArray *)btnList
{
    if (!_btnList) {
        _btnList = [NSMutableArray array];
    }
    return _btnList;
}
@end
