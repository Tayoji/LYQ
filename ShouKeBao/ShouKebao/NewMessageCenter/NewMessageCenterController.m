//
//  NewMessageCenterController.m
//  ShouKeBao
//
//  Created by 韩世民 on 15/11/6.
//  Copyright (c) 2015年 shouKeBao. All rights reserved.
//

#import "NewMessageCenterController.h"
#import "NewMessageCell.h"
#import "TerraceMessageController.h"
#import "ZhiVisitorDynamicController.h"
#import "ChatListCell.h"
#import "EaseMob.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "RobotManager.h"
#import "NSDate+Category.h"
#import "MessageCenterModel.h"
#import "IWHttpTool.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "LocationSeting.h"
#import "CustomHeaderAndNickName.h"
#import "BaseClickAttribute.h"
#import "MobClick.h"
#import "ServiceNotifiViewController.h"
#import "ChoseListViewController.h"
#import "MBProgressHUD+MJ.h"

#define fourSize ([UIScreen mainScreen].bounds.size.height == 480)
#define fiveSize ([UIScreen mainScreen].bounds.size.height == 568)
#define sixSize ([UIScreen mainScreen].bounds.size.height == 667)
#define sixPSize ([UIScreen mainScreen].bounds.size.height > 668)

#define kScreenSize [UIScreen mainScreen].bounds.size
@interface NewMessageCenterController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, ChatViewControllerDelegate,IChatManagerDelegate, EMCallManagerDelegate>
@property (nonatomic,strong) NSArray *NameArr;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) NSMutableArray *NamedataArr;//存放网络数据

@property (nonatomic, strong)NSMutableArray *chatListArray;//对话列表；
@property (nonatomic, strong)NSMutableArray *dynamicArray;//从服务器获取的上面两个列表的数据;


@property (nonatomic,strong) NSMutableArray *LocDataArr;//本地的搜索记录
@property (nonatomic,strong) NSMutableArray *searchDataArr;//服务器返回的数据
@property (nonatomic,strong) UITableView *SearTableView;
@property (nonatomic,strong) UIButton *cancalBtn;//自定义的取消button
//下边声明的都是新手引导1.5.0.0
@property (nonatomic,strong) UIView *backgroundIV;
@property (nonatomic,strong) UIImageView *guideView;
@property (nonatomic,strong) UIImageView *GuideTitImageV;
@property (nonatomic) UILabel *GuideconLabel;
@property (nonatomic,strong) UIButton *GuideIKnowBtn;
@property (nonatomic,strong) UIImageView *samllGuideImageV;
@property (nonatomic) NSInteger AddTapToGuide;//判断新手引导第几个界面

@end

@implementation NewMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    NSLog(@"chatlist%@", self.chatListArray);
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self registerNotifications];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![[defaults objectForKey:@"SetRedPacketjumpMesGuide"]  isEqual: @"1"]) {
        
            if(![[defaults objectForKey:@"NewGuideRadPacket"]  isEqual: @"1"]){
                NSLog(@"此处要显示引导页");
        [defaults setObject:@"1" forKey:@"NewGuideRadPacket"];
        [[[UIApplication sharedApplication].delegate  window]addSubview:self.backgroundIV];
        [[[UIApplication sharedApplication].delegate  window] addSubview:self.guideView];
        //引导页下边的小图标
        [[[UIApplication sharedApplication].delegate window] addSubview:self.samllGuideImageV];
             }
    }else{
        [defaults setObject:@"0" forKey:@"SetRedPacketjumpMesGuide"];
    }

    
    //[_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
}
- (void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"ShouKeBao_NewMessageCenterController"];
    [super viewWillAppear:animated];
    [self refreshDataSource];
}
- (void)loadMessageDataSource{
    
    //如果是来自管客户的界面，只显示IM聊天
    if (self.messageCenterType == FromCustom) {
        return;
    }
    NSMutableDictionary * params = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [IWHttpTool postWithURL:@"Notice/GetNoticeIndexContent" params:params success:^(id json) {
        NSLog(@".... %@", json);
        if ([json[@"IsSuccess"]integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MessageCenterModel * platformModel =[[MessageCenterModel alloc]init];
            MessageCenterModel * customDynamic =[[MessageCenterModel alloc]init];
            MessageCenterModel *serviceNotiDynamic =[[MessageCenterModel alloc]init];
            MessageCenterModel *choseNotiDynamic =[[MessageCenterModel alloc]init];
            platformModel.messageTitle = json[@"LastNoticeTitile"];
            platformModel.messageCount = json[@"NewNoticeCount"];
            platformModel.dateStr = json[@"LastNoticeDate"];
            
            customDynamic.messageTitle = json[@"LastDynamicTitile"];
            customDynamic.messageCount = json[@"NewDynamicCount"];
            customDynamic.dateStr = json[@"LastDynamicDate"];
            
            serviceNotiDynamic.messageTitle = json[@"LastAppMessageTitile"];
            serviceNotiDynamic.messageCount = json[@"NewAppMessageCount"];
            serviceNotiDynamic.dateStr = json[@"LastAppMessageDate"];
            
            choseNotiDynamic.messageTitle = json[@"LastEveryRecommendTitile"];
            choseNotiDynamic.messageCount = json[@"NewEveryRecommendCount"];
            choseNotiDynamic.dateStr = json[@"LastEveryRecommendDate"];
            
            [self.dynamicArray removeAllObjects];
            [self.dynamicArray addObject:platformModel];
            [self.dynamicArray addObject:serviceNotiDynamic];
            [self.dynamicArray addObject:customDynamic];
            [self.dynamicArray addObject:choseNotiDynamic];
            [self.tableView reloadData];
        }
        } failure:^(NSError *eror) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
-(void)refreshDataSource
{
    self.chatListArray = [self loadDataSource];
    [self loadMessageDataSource];
}
-(NSMutableArray *)dynamicArray {
    if (!_dynamicArray) {
        self.dynamicArray = [NSMutableArray array];
    }
    return _dynamicArray;
}
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    NSLog(@"%@", ret);
    return ret;
}

#pragma mark - UITableViewDelegate&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 2011) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2011) {
        if (section == 0) {
            return self.dynamicArray.count;
        }
        return self.chatListArray.count;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2011) {
        if (section == 0 || self.messageCenterType == FromCustom) {
            return 0;
        }

        return 20;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (tableView.tag == 2011) {
        return 70;
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 2011) {
        if (section == 0) {
            return 0;
        }
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 20)];
        headView.backgroundColor = [UIColor colorWithRed:(241.0/255.0) green:(242.0/255.0) blue:(244.0/255.0) alpha:1];
        return headView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2011) {
        ChatListCell *cell = [[ChatListCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
        if (indexPath.section == 0) {
            MessageCenterModel * model = self.dynamicArray[indexPath.row];
            cell.name = self.NameArr[indexPath.row];
            cell.unreadCount = [model.messageCount intValue];
            cell.detailMsg = model.messageTitle;
            NSLog(@"...%@ %@", model.messageTitle, model.dateStr);
            cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
            cell.time = model.dateStr;//年货采购节”开年率先登场，新春采购就上旅游圈，一年好运、财运滚滚来 
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"iconpingtai"];
            }else if (indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"SNotification"];
            }else if (indexPath.row == 3){
                cell.imageView.image = [UIImage imageNamed:@"iconfont-choseToday"];
            }else{
                cell.imageView.image = [UIImage imageNamed:@"iconzdongtai"];
            }
        }else{
            EMConversation *conversation = [self.chatListArray objectAtIndex:indexPath.row];
            NSLog(@"%@", conversation.chatter);
            if ([[LocationSeting defaultLocationSeting]getCustomInfoWithID:conversation.chatter]) {
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[LocationSeting defaultLocationSeting]getCustomInfoWithID:conversation.chatter][@"headerUrl"]] placeholderImage:[UIImage imageNamed:@"huanxinheader"]];
                cell.name = [[LocationSeting defaultLocationSeting]getCustomInfoWithID:conversation.chatter][@"nickName"];
            }else{
                [self getCustomIconAndNickNameWithChatter:conversation.chatter inCell:cell];
            }
            cell.unreadCount = [self unreadMessageCountByConversation:conversation];
            cell.detailMsg = [self subTitleMessageByConversation:conversation];
            cell.time = [self lastMessageTimeByConversation:conversation];
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    cell.textLabel.text = @"";
    return cell;
    
}
- (void)getCustomIconAndNickNameWithChatter:(NSString *)chatter
                                     inCell:(ChatListCell *)cell{
    NSDictionary *params = @{@"AppSkbUserId":chatter};
    [IWHttpTool postWithURL:@"Customer/GetAppDistributionSkbUserInfo" params:params success:^(id json) {
        if ([json[@"IsSuccess"]integerValue] == 1) {
            NSLog(@"%@", json);
            CustomHeaderAndNickName * model = [[CustomHeaderAndNickName alloc]init];
            model.headerUrl = json[@"HeadUrl"];
            model.nickName = json[@"NickName"];
            NSDictionary * dict = @{@"headerUrl":json[@"HeadUrl"], @"nickName":json[@"NickName"]};
            NSLog(@"%@###", dict);
            [[LocationSeting defaultLocationSeting] setCustomInfo:dict toID:chatter];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl] placeholderImage:[UIImage imageNamed:@"huanxinheader"]];
            cell.name = model.nickName;
        }
    } failure:^(NSError * error) {
        
    }];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2011&indexPath.section==1) {
        return YES;
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 2011) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"ShouKeBao_ZhiKeDynamicClick" attributes:dict];

                TerraceMessageController *Terr = [[TerraceMessageController alloc] init];
                [self.navigationController pushViewController:Terr animated:YES];
            }else if (indexPath.row == 1){
                ServiceNotifiViewController *seviceNotifiVC = [[ServiceNotifiViewController alloc]init];
                [self.navigationController pushViewController:seviceNotifiVC animated:YES];
            }else if(indexPath.row == 2){
                BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
                [MobClick event:@"ShouKeBao_customerDynamicClick" attributes:dict];
                
                ZhiVisitorDynamicController *zhiVisit = [[ZhiVisitorDynamicController alloc] init];
                zhiVisit.visitorDynamicFromType = VisitorDynamicTypeFromMessageCenter;
                [self.navigationController pushViewController:zhiVisit animated:YES];
            }else{
                ChoseListViewController *choseListVC = [[ChoseListViewController alloc]init];
                choseListVC.title = @"每日精选";
                choseListVC.DateStr = [self.dynamicArray[indexPath.row]dateStr];
                choseListVC.messageTitle = [self.dynamicArray[indexPath.row]messageTitle];
                [self.navigationController pushViewController:choseListVC animated:YES];
            }
            
            
        }else{
            EMConversation *conversation = [self.chatListArray objectAtIndex:indexPath.row];
            NSString *title = @"客户";
            if ([[LocationSeting defaultLocationSeting]getCustomInfoWithID:conversation.chatter]) {
                title = [[LocationSeting defaultLocationSeting]getCustomInfoWithID:conversation.chatter][@"nickName"];
            }
            NSString *chatter = conversation.chatter;
           ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:eConversationTypeChat];
            chatController.delelgate = self;
            chatController.title = title;
            if ([[RobotManager sharedInstance] getRobotNickWithUsername:chatter]) {
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:chatter];
            }
            [self.navigationController pushViewController:chatController animated:YES];
            
            BaseClickAttribute *dict = [BaseClickAttribute attributeWithDic:nil];
            [MobClick event:@"ShouKeBao_IMChatIconClick" attributes:dict];
            
            NSLog(@"我要往IM跳了,别拦我");
        }
    }else if(tableView.tag == 2012){
        NSLog(@"这是搜索的内容测试");
    }
    
   
}
#warning 下边这个方法需要修改
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2011) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // CustomModel *model = _dataArr[indexPath.row];
            //[self deleteTableViewCellwithId:model.ID];
            // 删除这行
            //[self.NamedataArr removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
   
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2011&indexPath.section == 1) {
        EMConversation *conversation = [self.chatListArray objectAtIndex:indexPath.row];
        UITableViewRowAction *toTop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//            NSLog(@"删除%ld,%ld",indexPath.section,indexPath.row);
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:NO append2Chat:NO];
            [self.chatListArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [tableView setEditing:NO animated:YES];
        }];
        toTop.backgroundColor =[UIColor redColor];
        NSString * markStr = @"";
        if (conversation.unreadMessagesCount) {
            markStr = @"标记已读";
        }else{
            markStr = @"标记未读";
        }
        UITableViewRowAction *toTop1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:markStr handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//            NSLog(@"标记未读%ld,%ld",indexPath.section,indexPath.row);
            if (conversation.unreadMessagesCount) {
                [conversation  markAllMessagesAsRead:YES];
            }else{
                [conversation markMessageWithId:[conversation latestMessage].messageId asRead:NO];
            }
            [self.tableView reloadData];
            [tableView setEditing:NO animated:YES];
        }];
        if (conversation.unreadMessagesCount) {
            toTop1.backgroundColor =[UIColor lightGrayColor];
        }else{
            toTop1.backgroundColor =[UIColor orangeColor];
        }
        return @[toTop,toTop1];
    }
    return nil;
}
#pragma mark - UISearchBarDelegate
//-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    [_SearchBar setShowsCancelButton:NO];
//    self.navigationController.navigationBarHidden=YES;
//
//    searchBar.frame = CGRectMake(0, 20, kScreenSize.width-50, 44);
//    
//    for(id cc in [searchBar.subviews[0] subviews])
//    {
//        if([cc isKindOfClass:[UIButton class]])
//        {
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitleColor:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
//        }
//    }
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self.searchView addSubview:self.SearTableView];
//    [self.view addSubview:self.cancalBtn];
//    [self.view.superview addSubview:self.searchView];
//
//    return YES;
//}
//
//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    for (UIView *searchbuttons in [[searchBar.subviews objectAtIndex:0] subviews])
//    {
//        if ([searchbuttons isKindOfClass:[UIButton class]])
//        {
//            UIButton *cancelButton = (UIButton *)searchbuttons;
//            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"取消"];
//            NSMutableDictionary *muta = [NSMutableDictionary dictionary];
//            [muta setObject:[UIColor colorWithRed:68/255.0 green:122/255.0 blue:208/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
//            [muta setObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
//            [attr addAttributes:muta range:NSMakeRange(0, 2)];
//            [cancelButton setAttributedTitle:attr forState:UIControlStateNormal];
//        }
//    }
//}
//实时下载 走下面方法
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    NSLog(@"正在下载，更新数据");
//    
//}

-(UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}
-(NSArray *)NameArr{
    if (!_NameArr) {
        _NameArr = [[NSArray alloc] initWithObjects:@"平台消息",@"业务通知", @"客人动态",@"每日精选", nil];
    }
    return _NameArr;
}
-(NSMutableArray *)NamedataArr{
    if (!_NamedataArr) {
        _NamedataArr = [[NSMutableArray alloc] initWithObjects:@"预谋",@"了好久",@"贺成祥", nil];
    }
    return _NamedataArr;
}
-(UIButton *)cancalBtn{
    if (!_cancalBtn) {
        _cancalBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 50, 20, 50, 44)];
        //_cancalBtn.backgroundColor = [UIColor colorWithRed:(232.0/225.0) green:(233.0/255.0) blue:(234.0/255.0) alpha:1];
        [_cancalBtn setBackgroundColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235.0/255.0 alpha:1]];
        [_cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_cancalBtn addTarget:self action:@selector(BtnClickdasf) forControlEvents:UIControlEventTouchUpInside];
        
        //加一块黑边
        UIView *blackBound = [[UIView alloc] initWithFrame:CGRectMake(0,43.5, 50, 0.5)];
        blackBound.backgroundColor = [UIColor colorWithRed:(80.0/255.0) green:(81.0/255.0) blue:(81.0/255.0) alpha:1];
        [_cancalBtn addSubview:blackBound];
    }
    return _cancalBtn;
}
-(void)BtnClickdasf{
    NSLog(@"正在点击");
    _SearchBar.text = @"";
    self.navigationController.navigationBarHidden=NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _SearchBar.frame = CGRectMake(0, 0, kScreenSize.width, 44);
    [self.searchView removeFromSuperview];
    [_SearchBar setShowsCancelButton:NO];
    [_SearchBar resignFirstResponder];
    [_cancalBtn removeFromSuperview];
}
-(UITableView *)SearTableView{
    if (!_SearTableView) {
        _SearTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
        _SearTableView.tag = 2012;
        _SearTableView.delegate = self;
        _SearTableView.dataSource = self;
//        _SearTableView.tableFooterView = [[UIView alloc]init];
    }
    return _SearTableView;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始滚动了");
    [_SearchBar resignFirstResponder];
    
    for(id control in [_SearchBar subviews])
    {
        NSLog(@"%@",control);
        
            UIButton * btn =(UIButton *)control;
            btn.enabled=YES;
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShouKeBao_NewMessageCenterController"];
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击搜索了");
}



// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}
// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"[图片]", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
                } else {
                    ret = didReceiveText;
                }
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"[音频]", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}
// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}
-(void)didReceiveMessage:(EMMessage *)message
{
    self.chatListArray = [self loadDataSource];
    [self.tableView reloadData];
}
#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(UIView *)backgroundIV{
    if (!_backgroundIV) {
        _backgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        [_backgroundIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1)]];
        _backgroundIV.userInteractionEnabled = YES;
        _backgroundIV.backgroundColor = [UIColor blackColor];
        _backgroundIV.alpha = 0.4;
    }
    return _backgroundIV;
}
-(void)click1{
    if (self.GuideIKnowBtn.tag == 101) {
        self.GuideTitImageV.image = [UIImage imageNamed:@"NewRadPToday"];
        self.GuideconLabel.text = @"分享这里的产品下单效率更好哦!";
        self.GuideIKnowBtn.tag = 102;
        [self.GuideIKnowBtn setTitle:@"立即查看" forState:UIControlStateNormal];
        [self.samllGuideImageV setImage:[UIImage imageNamed:@"NewRadPTodaySmall"]];
    }else if (self.GuideIKnowBtn.tag == 102){
        [self.backgroundIV removeFromSuperview];
        [self.guideView removeFromSuperview];
        [self.samllGuideImageV removeFromSuperview];
    }
   
    
}
-(UIImageView *)guideView{
    if (!_guideView) {
        _guideView =[[UIImageView alloc] init];
        if (fourSize) {
            _guideView.frame = CGRectMake(10, kScreenSize.height/4, kScreenSize.width-20, 180);
        }else if(fiveSize){
            _guideView.frame = CGRectMake(10, kScreenSize.height/4, kScreenSize.width-20, 180);
        }else{
            _guideView.frame = CGRectMake(30, kScreenSize.height/4, kScreenSize.width-60, 180);

        }
        _guideView.userInteractionEnabled = YES;
        [_guideView setImage:[UIImage imageNamed:@"RadPGuideBG"]];
        
       [_guideView addSubview:self.GuideIKnowBtn];
        [_guideView addSubview:self.GuideconLabel];
        [_guideView addSubview:self.GuideTitImageV];
    }
    return _guideView;
}
-(UIButton *)GuideIKnowBtn{
    if (!_GuideIKnowBtn) {
        _GuideIKnowBtn =[[UIButton alloc] init];
//        if (fourSize) {
//            _GuideIKnowBtn.frame = CGRectMake(_guideView.frame.size.width/2-50, 125, 100, 30);
//        }else if(fiveSize){
//            _GuideIKnowBtn.frame = CGRectMake(_guideView.frame.size.width/2-50, 125, 100, 30);
//
//        }else{
            _GuideIKnowBtn.frame = CGRectMake(_guideView.frame.size.width/2-50, 125, 100, 30);

//        }
        [_GuideIKnowBtn setBackgroundImage:[UIImage imageNamed:@"AnomalyBg"] forState:UIControlStateNormal];
        [_GuideIKnowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        _GuideIKnowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _GuideIKnowBtn.tag = 101;
        [_GuideIKnowBtn addTarget:self action:@selector(guideClick:) forControlEvents:UIControlEventTouchUpInside];
        [_GuideIKnowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _GuideIKnowBtn;
}

-(UILabel *)GuideconLabel{
    if (!_GuideconLabel) {
        _GuideconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, _guideView.frame.size.width-20, 40)];
        _GuideconLabel.text = @"关于订单，钱，现金券的信息集中营";
        _GuideconLabel.numberOfLines = 2;
        _GuideconLabel.textAlignment = NSTextAlignmentCenter;
        _GuideconLabel.font = [UIFont systemFontOfSize:16];
        _GuideconLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    }
    return _GuideconLabel;
}
-(UIImageView *)GuideTitImageV{
    if (!_GuideTitImageV) {
        _GuideTitImageV = [[UIImageView alloc] initWithFrame:CGRectMake(_guideView.frame.size.width/2-60, 40, 120, 25)];
        _GuideTitImageV.image = [UIImage imageNamed:@"NewBusiness"];
    }
    return _GuideTitImageV;
}
-(UIImageView *)samllGuideImageV{
    if (!_samllGuideImageV) {
        _samllGuideImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-30, kScreenSize.height/4+225, 60, 60)];
        [_samllGuideImageV setImage:[UIImage imageNamed:@"NewBusinesSamll"]];
    }
    return _samllGuideImageV;
}
-(void)guideClick:(UIButton *)button{
    if (button.tag == 101) {
        self.GuideTitImageV.image = [UIImage imageNamed:@"NewRadPToday"];
        self.GuideconLabel.text = @"分享这里的产品下单效率更好哦!";
        self.GuideIKnowBtn.tag = 102;
        [self.GuideIKnowBtn setTitle:@"立即查看" forState:UIControlStateNormal];
        [self.samllGuideImageV setImage:[UIImage imageNamed:@"NewRadPTodaySmall"]];
    }else if(button.tag == 102){
        [self.backgroundIV removeFromSuperview];
        [self.guideView removeFromSuperview];
        [self.samllGuideImageV removeFromSuperview];
        ChoseListViewController *choseListVC = [[ChoseListViewController alloc]init];
        choseListVC.title = @"每日精选";
        [self.navigationController pushViewController:choseListVC animated:YES];

    }
}
@end
