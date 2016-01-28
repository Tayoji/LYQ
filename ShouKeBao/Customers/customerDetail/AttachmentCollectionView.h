//
//  AttachmentCollectionView.h
//  ShouKeBao
//
//  Created by 冯坤 on 15/10/16.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    fromTypeCustom,
    fromTypeOrderDetail,
    fromTypeUpdateContract
}TheFromType;
@interface AttachmentCollectionView : UICollectionViewController
@property (nonatomic, strong)UIViewController * OrderVC;
@property (nonatomic,copy) NSString *customerId;
@property (nonatomic, assign)TheFromType fromType;

//@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic, strong)NSArray * pictureList;
@end
