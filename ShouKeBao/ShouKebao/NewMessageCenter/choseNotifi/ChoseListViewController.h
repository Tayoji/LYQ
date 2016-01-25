//
//  ChoseListViewController.h
//  ShouKeBao
//
//  Created by 张正梅 on 16/1/5.
//  Copyright © 2016年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"

@interface ChoseListViewController : SKViewController
@property (weak, nonatomic) IBOutlet UITableView *choseTableView;
@property (nonatomic, copy)NSString *DateStr;
@property (nonatomic, copy)NSString *messageTitle;
@end
