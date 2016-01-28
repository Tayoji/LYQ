//
//  NewExclusiveAppIntroduceViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 15/12/8.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

typedef enum{
    FromProductDetail,
    FromMe,
}pushFrom;
@interface NewExclusiveAppIntroduceViewController : SKViewController
@property (nonatomic, strong)UINavigationController *naVC;
@property (nonatomic, assign)pushFrom *pushFrom;
@end
