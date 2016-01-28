//
//  CustomModel.h
//  ShouKeBao
//
//  Created by 吴铭 on 15/3/30.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject
//@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString *HeadUrl;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *NickName;
@property (nonatomic,copy) NSString *Mobile;
@property (nonatomic,copy) NSString *OrderCount;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *QQCode;
@property (nonatomic,copy) NSString *Remark;
@property (nonatomic,copy) NSString *WeiXinCode;
@property (nonatomic,copy) NSString *PicUrl;
@property (nonatomic,copy) NSString *Nationality;
@property (nonatomic,copy) NSString *BirthDay;
@property (nonatomic,copy) NSString *ValidStartDate;
@property (nonatomic,copy) NSString *ValidAddress;
@property (nonatomic,copy) NSString *CardNum;
@property (nonatomic,copy) NSString *ValidEndDate;
@property (nonatomic,copy) NSString *Address;
@property (nonatomic,copy) NSString *Sex;
@property (nonatomic,copy) NSString *Country;
@property (nonatomic,copy) NSString *PassportNum;
@property (nonatomic, strong)NSArray *PictureList;
//@property (nonatomic,copy) NSString *HearUrl;

@property (nonatomic, strong)NSString *AppSkbUserId;

@property (nonatomic,copy) NSString *GroupbyType;
//@property (strong, nonatomic)NSNumber *GroupbyType;
//判断是不是已是专属客户
@property (nonatomic,copy)NSString *IsOpenIM;


+ (instancetype)modalWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
