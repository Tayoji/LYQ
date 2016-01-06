//
//  ServiceModel.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel
+(ServiceModel *)modelWithDic:(NSDictionary *)dic{
    ServiceModel *model = [[ServiceModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
