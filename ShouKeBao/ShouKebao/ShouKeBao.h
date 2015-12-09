//
//  ShouKeBao.h
//  ShouKeBao
//
//  Created by David on 15/3/12.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Customers.h"

@interface ShouKeBao : SKViewController
@property(nonatomic,weak) UILabel *warningLab;
@property (nonatomic, strong)Customers *customerMessage;
@end
