//
//  SWGroupMemberViewController.m
//  ShenWU
//
//  Created by Amy on 2024/6/27.
//

#import "SWGroupMemberViewController.h"
#import "SWGroupMemberCell.h"
#import "SWSearchView.h"
//#import "FGroupFriendInfoViewController.h"
#import "SWGroupInfoViewController.h"

@interface SWGroupMemberViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SWGroupMemberInfoViewControllerDelegate>
@property(nonatomic, strong) SWSearchView *searchView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic, assign) BOOL isSearch;
@property(nonatomic, strong) NSString *searchContent;
@property (nonatomic,strong) NSMutableArray *searchList;
@property (nonatomic,strong) NSString *hostUserId;
@property(nonatomic, assign) NSInteger pageNum;
@end

@implementation SWGroupMemberViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldFontWithSize: 17],NSForegroundColorAttributeName:UIColor.blackColor};
//    self.navigationController.navigationBar.titleTextAttributes = attribute;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"查看群成员";
    self.pageNum = 1;
    if (self.type != GroupMemberTypeLook) {
        self.dataList = [NSMutableArray array];
        for (FGroupUserInfoModel *model in self.model.members) {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:model.modelToJSONObject];
            [self.dataList addObject:[FGroupUserInfoModel modelWithDictionary:dict]];
        }
    }else{
        self.dataList = [NSMutableArray arrayWithArray:self.model.members];
    }
    
    self.searchList = [NSMutableArray array];
    
    self.searchView = [[SWSearchView alloc] initWithFrame:CGRectMake(16, kTopHeight+19, kScreenWidth - 32, 40)];
    self.searchView.placeholder = @"搜索你要查找的账号";
    @weakify(self)
    self.searchView.searchBlock = ^(NSString * _Nonnull content) {
        weak_self.isSearch = YES;
        [weak_self searchUser:content];
    };
    self.searchView.endSearchBlock = ^{
        weak_self.isSearch = NO;
        weak_self.searchContent = @"";
        [weak_self.collectionView reloadData];
    };
    [self.view addSubview:self.searchView];
    
    [self.view addSubview:self.collectionView];
    
    [self changeView];
    
}



- (void)changeView{
    switch (self.type) {
        case GroupMemberTypeLook:
            self.title = @"查看群成员";
            break;
        case GroupMemberTypeSelectHost:
        {
            self.title = @"选择新群主";
            UIButton *sureBtn = [FControlTool createCommonButtonWithText:@"确定" target:self sel:@selector(sureBtnAction)];
            sureBtn.frame = CGRectMake(37, kScreenHeight - 84, kScreenWidth - 74, 44);
            [self.view addSubview:sureBtn];
        }
            break;
        case GroupMemberTypeSelectManage:
        {
            self.title = @"选择管理员";
            UIButton *sureBtn = [FControlTool createCommonButtonWithText:@"确定" target:self sel:@selector(sureBtnAction)];
            sureBtn.frame = CGRectMake(37, kScreenHeight - 84, kScreenWidth - 74, 44);
            [self.view addSubview:sureBtn];
        }
            break;
        default:
            break;
    }
}

- (void)searchUser:(NSString *)content{
    [self.searchList removeAllObjects];
    for (FGroupUserInfoModel *user in self.dataList) {
        if ([user.name.lowercaseString matchSearch:content.lowercaseString]) {
            [self.searchList addObject:user];
        }
    }
    [self.collectionView reloadData];
}

- (void)sureBtnAction{
    if (self.type == GroupMemberTypeSelectHost) {
        if (self.hostUserId.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择"];
            return;
        }
        NSDictionary *params = @{@"groupId":self.model.groupId,@"newGroupUserId":self.hostUserId};
        @weakify(self)
        [SVProgressHUD show];
        [[FNetworkManager sharedManager] postRequestFromServer:@"/group/transferGroup" parameters:params success:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue] == 200) {
                weak_self.model.members = self.dataList;
                UIViewController *settingVc;
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[SWGroupInfoViewController class]]) {
                        settingVc = vc;
                    }
                }
                if (settingVc) {
                    [weak_self.navigationController popToViewController:settingVc animated:YES];
                }else{
                    [weak_self.navigationController popViewControllerAnimated:YES];
                }
                if (weak_self.reloadBlock) {
                    weak_self.reloadBlock();
                }
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"msg"]];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - FGroupFriendInfoViewControllerDelegate
- (void)reloadGroupMember{
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return self.searchList.count;
    }else{
        return self.dataList.count;
    }
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWGroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SWGroupMemberCell class]) forIndexPath:indexPath];
    cell.nameLabel.hidden = NO;
    cell.tagLabel.hidden = NO;
    cell.avatarImgView.frame = CGRectMake(0, 0, 44, 44);
    cell.avatarImgView.layer.cornerRadius = 4;
    cell.tagLabel.frame = CGRectMake(0, 29, 44, 15);
    cell.nameLabel.frame = CGRectMake(0, cell.avatarImgView.bottom+8, 44, 17);
    FGroupUserInfoModel *model = nil;
    if (self.isSearch) {
        model = [self.searchList objectAtIndex:indexPath.item];
    }else{
        model = [self.dataList objectAtIndex:indexPath.item];
    }
    [cell refreshCellWithData:model];
    if (self.type == GroupMemberTypeSelectHost) {
        if (model.rankState != 1) {
            cell.tagLabel.hidden = YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type != GroupMemberTypeLook) {
        FGroupUserInfoModel *model = nil;
        if (self.isSearch) {
            model = [self.searchList objectAtIndex:indexPath.item];
        }else{
            model = [self.dataList objectAtIndex:indexPath.item];
        }
        if (self.type == GroupMemberTypeSelectHost) {
            for (FGroupUserInfoModel *item in self.dataList) {
                item.rankState = 3;
            }
            model.rankState = 1;
            self.hostUserId = model.userId;
            [self.collectionView reloadData];
        }else{
            if (model.rankState == 1) {
                return;
            }
            if (model.rankState == 2) {
                [self handleManager:model.userId state:@"1" success:^{
                    model.rankState = 3;
                    [self.collectionView reloadData];
                }];
            }else{
                [self handleManager:model.userId state:@"0" success:^{
                    model.rankState = 2;
                    [self.collectionView reloadData];
                }];
            }
        }
        
    }else{
        if (self.isSearch) {
            [[FUserRelationManager sharedManager] clickGroupMember:[self.searchList objectAtIndex:indexPath.item] group:self.model delegate:self];
        }else{
            [[FUserRelationManager sharedManager] clickGroupMember:[self.dataList objectAtIndex:indexPath.item] group:self.model delegate:self];
        }
    }
}

- (void)handleManager:(NSString*)userId state:(NSString*)state success:(void(^)(void))success{
    @weakify(self)
    NSDictionary *cancelParams = @{@"groupId":self.model.groupId,@"members":@[userId],@"state":state};
    [SVProgressHUD show];
    [[FNetworkManager sharedManager] postRequestFromServer:@"/group/installAdmin" parameters:cancelParams success:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue] == 200) {
            weak_self.model.members = self.dataList;
            if (weak_self.reloadBlock) {
                weak_self.reloadBlock();
            }
            success();
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"msg"]];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = (kScreenWidth - 60 - 44*6)/5;
        layout.minimumInteritemSpacing = 20;
        layout.itemSize = CGSizeMake(44, 69);
        layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.searchView.bottom+19, kScreenWidth, kScreenHeight - (self.searchView.bottom+19)) collectionViewLayout:layout];
        [_collectionView registerClass:[SWGroupMemberCell class] forCellWithReuseIdentifier:NSStringFromClass([SWGroupMemberCell class])];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
