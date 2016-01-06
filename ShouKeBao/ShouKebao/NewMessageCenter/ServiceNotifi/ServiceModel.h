//
//  ServiceModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceModel : BaseModel
@property (nonatomic, strong)NSString *MessageType;
@property (nonatomic, strong)NSString *MessageTitle;
@property (nonatomic, strong)NSString *MessageContent;
@property (nonatomic, strong)NSString *LyqAppUserId;
@property (nonatomic, strong)NSString *ReadState;
@property (nonatomic, strong)NSString *BusinessId;
+(ServiceModel *)modelWithDic:(NSDictionary *)dic;
@end
