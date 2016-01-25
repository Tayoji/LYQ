//
//  ChoseModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/22.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ChoseModel : BaseModel
@property (nonatomic, copy)NSString *Copies;
@property (nonatomic, strong)NSDictionary *Productdetail;
@property (nonatomic, copy)NSString *PushDate;
@property (nonatomic, copy)NSString *PushDateText;

+(instancetype)modalWithDict:(NSDictionary *)dict;
@end
