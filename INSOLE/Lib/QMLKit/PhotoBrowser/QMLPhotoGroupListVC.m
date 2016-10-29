//
//  QMLPhotoGroupListVC.m
//  USENSE
//
//  Created by Myron on 16/1/5.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLPhotoGroupListVC.h"
#import "ALAssetsLibrary+instance.h"
@interface QMLPhotoGroupListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *statusView;
    UIView *barView;
    UILabel *titleLa;
    
    NSMutableArray *dataToShow;
    
    UITableView *tab;
}
@end

const  NSString *QML_PHOTO_GROUP_LIST_VC_INFO_TITLE                   = @"QML_PHOTO_GROUP_LIST_VC_INFO_TITLE";
const  NSString *QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_DEFAULT      = @"QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_DEFAULT";
const  NSString *QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_HIGH_LIGHTED = @"QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_HIGH_LIGHTED";
const  NSString *QML_PHOTO_GROUP_LIST_VC_INFO_BAR_COLOR               = @"QML_PHOTO_GROUP_LIST_VC_INFO_BAR_COLOR";

@implementation QMLPhotoGroupListVC
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataToShow = [NSMutableArray array];
    self.view.backgroundColor = COLOR_WITH_RGB(226,233,232);
    self.title = [self.infoDict objectForKey:QML_PHOTO_GROUP_LIST_VC_INFO_TITLE];
    self.title = self.title?self.title:@"相册列表";
    UIColor *barColor = [self.infoDict objectForKey:QML_PHOTO_GROUP_LIST_VC_INFO_BAR_COLOR];
    barColor = barColor?barColor:COLOR_WITH_RGB(42, 45, 51);
    
    UIImage *defaultImg = [self.infoDict objectForKey:QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_DEFAULT];
    UIImage *selectedImg = [self.infoDict objectForKey:QML_PHOTO_GROUP_LIST_VC_INFO_BACK_IMAGE_HIGH_LIGHTED];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    if (!barView) {
        float w = self.view.frame.size.width;
        
        statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 20)];
        statusView.backgroundColor = barColor;
        [self.view addSubview:statusView];
        
        
        barView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, w, 44)];
        barView.backgroundColor = barColor;
        [self.view addSubview:barView];
        
        titleLa = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, w-100, 44)];
        titleLa.backgroundColor = [UIColor clearColor];
        titleLa.textColor = [UIColor whiteColor];
        titleLa.font = [UIFont systemFontOfSize:18];
        titleLa.text = self.title;
        titleLa.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLa];
        
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(0, 20, 43, 44);
        if (defaultImg) {
            [backBtn setImage:defaultImg forState:UIControlStateNormal];
        }
        if (selectedImg) {
            [backBtn setImage:selectedImg forState:UIControlStateHighlighted];
        }
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(14, 17, 14, 17);
        [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        
        [self readGroups];
    }
    
}
-(void)getGroup:(ALAssetsGroup *)group complete:(BOOL)complete{
    if (complete) {
        if (!tab) {
            tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
            tab.delegate = self;
            tab.dataSource = self;
            tab.rowHeight = 100;
            tab.separatorStyle = UITableViewCellSeparatorStyleNone;
            tab.backgroundColor = [UIColor clearColor];
            [self.view addSubview:tab];
        }else{
            [tab reloadData];
        }
    }else{
        LOG_D(@"group ::%@",group);
        [dataToShow addObject:group];
    }
}
-(void)readGroups{
    __weak typeof(self)bSelf = self;
    [[ALAssetsLibrary sharedAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        LOG_D(@"group ::%@",group);
        [bSelf getGroup:group complete:!group];
        
    } failureBlock:^(NSError *error) {
        
    }];
}
-(void)backToPre{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataToShow.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.backgroundColor = COLOR_WITH_RGB(245, 250, 249);
        
        UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        im.tag = 1;
        [cell.contentView addSubview:im];
        
        UIFont *titleFont = [UIFont systemFontOfSize:18];
        UIFont *descFont = [UIFont systemFontOfSize:12];
        float x = 100;
        float w = self.view.frame.size.width - x ;
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(x, 20, w, titleFont.lineHeight)];
        la.font = titleFont;
        la.textColor = COLOR_WITH_RGB(21, 23, 28);
        la.tag = 2;
        [cell.contentView addSubview:la];
        
        UILabel *descLa = [[UILabel alloc] initWithFrame:CGRectMake(x, 20+titleFont.lineHeight+10, w, descFont.lineHeight)];
        descLa.font = descFont;
        descLa.textColor = COLOR_WITH_RGB(97, 102, 114);
        descLa.tag = 3;
        [cell.contentView addSubview:descLa];
    }
    ALAssetsGroup *group = [dataToShow objectAtIndex:indexPath.row];
    
    
    UIImageView *im = (UIImageView *)[cell.contentView viewWithTag:1];
    im.image = [UIImage imageWithCGImage:[group posterImage]];
    
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
    
    UILabel *nameLa = (UILabel *)[cell.contentView viewWithTag:2];
    nameLa.text = name;
    
    UILabel *descLa = (UILabel *)[cell.contentView viewWithTag:3];
    descLa.text = [NSString stringWithFormat:@"%d张照片",(int)[group numberOfAssets]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    if (self.didSelectedGroup) {
        self.didSelectedGroup([dataToShow objectAtIndex:indexPath.row]);
    }
}
@end
