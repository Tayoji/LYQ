//
//  ChoseModel.m
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/22.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "ChoseModel.h"
#import "NSMutableDictionary+QD.h"
@implementation ChoseModel
+(instancetype)modalWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
//        NSMutableDictionary * dic = [NSMutableDictionary cleanNullResult:dict];

        self.Productdetail = dict[@"Productdetail"];
        [self setValuesForKeysWithDictionary:[NSMutableDictionary cleanNullResult:dict]];
    }
    return self;
}



@end
