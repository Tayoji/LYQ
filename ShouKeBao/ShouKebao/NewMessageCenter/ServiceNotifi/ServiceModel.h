//
//  ServiceModel.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceModel : BaseModel
@property (nonatomic, copy)NSString *MessageType;
@property (nonatomic, copy)NSString *MessageTitle;
@property (nonatomic, copy)NSString *MessageContent;
@property (nonatomic, copy)NSString *MessageId;
@property (nonatomic, copy)NSString *ReadState;
@property (nonatomic, copy)NSString *BusinessId;
@property (nonatomic, copy)NSString *LinkUrl;
@property (nonatomic, copy)NSString *MessageTypeText;
@property (nonatomic, copy)NSString *CreateTimeText;
@property (nonatomic, copy)NSString *CreateTime;
+(ServiceModel *)modelWithDic:(NSDictionary *)dic;
@end
