//
//  SelectCustomerController.h
//  ShouKeBao
//
//  Created by 韩世民 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
typedef enum {
    FromeRedPacket,
    FromeProDetail
}From;
@interface SelectCustomerController : SKViewController
@property (nonatomic,assign) From FromWhere;
@end
