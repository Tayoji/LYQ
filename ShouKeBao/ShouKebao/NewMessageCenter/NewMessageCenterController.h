//
//  NewMessageCenterController.h
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "SKViewController.h"
typedef enum : NSUInteger{
    FromSKB,
    FromCustom
} MessageCenterType;

@interface NewMessageCenterController : SKViewController
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)MessageCenterType messageCenterType;

@end
