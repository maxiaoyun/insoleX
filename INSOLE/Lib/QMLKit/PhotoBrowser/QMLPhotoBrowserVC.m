//
//  QMLPhotoBrowserVC.m
//  testQMLKit
//
//  Created by Myron on 15/11/9.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLPhotoBrowserVC.h"
#import "QMLPhotoCollectionCell.h"
#import "QMLPhotoGroupListVC.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "ALAssetsLibrary+instance.h"

@interface QMLPhotoBrowserVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGRect contentFrame;
    UICollectionView *cntView;
    NSMutableArray *mediaArray;
    
    UIImage *selectImg;
    UIImage *defaultImg;
    
    float i_w ;
    
    UIView *statusView;
    UIView *barView;
    UILabel *titleLa;
    
    UIButton *doneBut;
    
    
    NSMutableArray *selectAssetArr;
    NSMutableDictionary *selectAssetDict;
}
@end

@implementation QMLPhotoBrowserVC
- (void)dealloc
{
    DEALLOC_PRINT;
}
-(UICollectionView *)collectionView{
    return cntView;
}
-(UIView *)barView{
    return barView;
}
-(UIView*)statusView{
    return statusView;
}
-(UILabel *)titleLa{
    return titleLa;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}
-(void)presentGroupListWithInfoDict:(NSDictionary *)infoDict{
    QMLPhotoGroupListVC *list = [[QMLPhotoGroupListVC alloc] init];
    list.statusBarStyle = self.statusBarStyle;
    list.infoDict = infoDict;
    __weak typeof(self)bSelf = self;
    __weak typeof(list)bList = list;
    list.didSelectedGroup = ^(ALAssetsGroup *group){
        [bSelf showPhotosWithGroup:group];
        [bList dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:list animated:YES completion:nil];
    
}
-(void)showPhotosWithGroup:(ALAssetsGroup *)group{
    self.group = group;
}
-(void)makeDoneBtnFront{
    [self.view bringSubviewToFront:doneBut];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    if (self.sourceType==0) {
        self.sourceType = UBCPhotoBrowserSourceTypePhoto;
    }
    
    self.rowCntInSection = self.rowCntInSection<1?4:self.rowCntInSection;
    self.doneTitle = self.doneTitle?self.doneTitle:@"完成";
    
    if (!self.title) {
        if (self.group) {
            self.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
        }else{
            self.title = @"Photos Album";
        }
    }
    
    if (!selectAssetArr) {
        selectAssetArr = [NSMutableArray array];
    }
    if (!selectAssetDict) {
        selectAssetDict = [NSMutableDictionary dictionary];
    }
    
    if (!barView) {
        float w = self.view.frame.size.width;
        
        statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 20)];
        statusView.backgroundColor = COLOR_WITH_RGB(42, 45, 51);
        [self.view addSubview:statusView];
        
        
        barView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, w, 44)];
        barView.backgroundColor = COLOR_WITH_RGB(42, 45, 51);
        [self.view addSubview:barView];
        
        titleLa = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, w-100, 44)];
        titleLa.backgroundColor = [UIColor clearColor];
        titleLa.textColor = [UIColor whiteColor];
        titleLa.font = [UIFont systemFontOfSize:18];
        titleLa.text = self.title;
        titleLa.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLa];
        
        NSString *title = [NSString stringWithFormat:@"%@(%d/%d)",self.doneTitle,(int)selectAssetArr.count,self.limit];
        UIFont *doneFont = self.doneFont?self.doneFont:[UIFont systemFontOfSize:18];
        UIColor *doneColor = self.doneColor?self.doneColor:COLOR_WITH_RGB(249, 98, 98);
        CGFloat r,g,b,a;
        [doneColor getRed:&r green:&g blue:&b alpha:&a];
        
        if (self.sourceType==UBCPhotoBrowserSourceTypeVideo) {
            
        }else{
            float t_w = [title sizeWithAttributes:@{NSFontAttributeName:doneFont}].width;
            doneBut = [UIButton buttonWithType:UIButtonTypeCustom];
            doneBut.frame = CGRectMake(w - 17 - 100, 0, 100, 44);
            [doneBut setTitle:title forState:UIControlStateNormal];
            doneBut.titleLabel.font = doneFont;
            [doneBut setTitleColor:doneColor forState:UIControlStateNormal];
            [doneBut setTitleColor:[UIColor colorWithRed:r*.7 green:g*.7 blue:b*.7 alpha:a] forState:UIControlStateHighlighted];
            doneBut.titleLabel.textAlignment = NSTextAlignmentRight;
            doneBut.titleEdgeInsets = UIEdgeInsetsMake(0, (100-t_w), 0, 0);
            [doneBut addTarget:self action:@selector(doneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [barView addSubview:doneBut];
        }
    }
    
    
    if (!mediaArray) {
        mediaArray = [NSMutableArray array];
    }
    contentFrame = self.view.frame;
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.getCntFrame){
        contentFrame = self.getCntFrame();
    }
    
    i_w = (self.view.frame.size.width - 5*(self.rowCntInSection+1))/self.rowCntInSection;
    
    
    if (self.setTintImg) {
        UIImage *s_view = selectImg;
        UIImage *d_view = defaultImg;
        self.setTintImg(&d_view,&s_view);
        
        selectImg = s_view;
        defaultImg = d_view;
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    cntView = [[UICollectionView alloc] initWithFrame:contentFrame collectionViewLayout:flowLayout];
    [cntView registerClass:[QMLPhotoCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    cntView.delegate = self;
    cntView.dataSource = self;
    cntView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cntView];
    
    [self reloadData];
    if (self.didCreateView) {
        self.didCreateView();
    }
}
-(NSArray *)results{
    NSMutableArray *result = [NSMutableArray array];
    for (ALAsset *asset in selectAssetArr) {
        CGImageRef ref = [[asset defaultRepresentation] fullScreenImage];
        
        [result addObject:@{@"image":[UIImage imageWithCGImage:ref],@"url":[[asset defaultRepresentation] url]}];
    }
    return result;
}
-(void)doneBtnPressed{
    if (self.doneBtnClick) {
        NSArray *result = [self results];
        self.doneBtnClick(result);
    }
}
-(void)setGroup:(ALAssetsGroup *)group{
    SET_PAR(_group, group);
    titleLa.text = [group valueForProperty:ALAssetsGroupPropertyName];
    [self reloadData];
}
-(BOOL)shouldInsert:(NSString *)type{
    if ([type isEqualToString:ALAssetTypePhoto]) {
        return (self.sourceType&UBCPhotoBrowserSourceTypePhoto)==UBCPhotoBrowserSourceTypePhoto;
    }
    if ([type isEqualToString:ALAssetTypeVideo]) {
        return (self.sourceType&UBCPhotoBrowserSourceTypeVideo)==UBCPhotoBrowserSourceTypeVideo;
    }
    return NO;
}
-(void)selectAsset:(ALAsset *)asset{
    if (!selectAssetArr) {
        selectAssetArr = [NSMutableArray array];
    }
    if (!selectAssetDict) {
        selectAssetDict = [NSMutableDictionary dictionary];
    }
    NSURL *url = [[asset defaultRepresentation] url];
    if (![selectAssetDict objectForKey:url]) {
        [selectAssetDict setObject:asset forKey:url];
        [selectAssetArr addObject:asset];
    }
}
-(void)deseleAsset:(ALAsset *)asset{
    if (!selectAssetArr) {
        selectAssetArr = [NSMutableArray array];
    }
    if (!selectAssetDict) {
        selectAssetDict = [NSMutableDictionary dictionary];
    }
    NSURL *url = [[asset defaultRepresentation] url];
    id value = [selectAssetDict objectForKey:url];
    if (value) {
        [selectAssetDict removeObjectForKey:url];
        [selectAssetArr removeObject:value];
    }
}
-(BOOL)didSelectAsset:(ALAsset *)asset{
    if (!selectAssetArr) {
        selectAssetArr = [NSMutableArray array];
    }
    NSURL *url = [[asset defaultRepresentation] url];
    id value = [selectAssetDict objectForKey:url];
    if (value) {
        return YES;
    }
    return NO;
}
-(void)insert:(ALAsset *)asset selected:(BOOL)selected{
    NSURL *url = [[asset defaultRepresentation] url];
    if (!mediaArray) {
        mediaArray = [NSMutableArray array];
    }
    [mediaArray insertObject:@{@"asset":asset,@"selected":@(selected),@"url":url} atIndex:0];
    if (selected) {
        [self selectAsset:asset];
    }else{
        [self deseleAsset:asset];
    }
    [self reloadView];
}
-(void)readPhotoWithGroup:(ALAssetsGroup *)group{
    BOOL (^imgSelected)(NSURL*) = self.imageSelected;
    __weak typeof(self)bSelf = self;
    __block int cnt = 0;
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result){
            cnt ++ ;
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            if ([self shouldInsert:type]) {
                NSURL *url = [[result defaultRepresentation] url];
                if (url) {
                    BOOL selected = NO;
                    if (imgSelected) {
                        selected = imgSelected(url);
                    }
                    if (!selected) {
                        selected = [self didSelectAsset:result];
                    }
                    if (selected) {
                        [bSelf selectAsset:result];
                    }else{
                        [bSelf deseleAsset:result];
                    }
                    //[mediaArray addObject:@{@"asset":result,@"selected":@(selected),@"url":url}];
                    [mediaArray insertObject:@{@"asset":result,@"selected":@(selected),@"url":url} atIndex:0];
                }
            }
        }else{
            QMLog(@"mediaArray.count 1:%d",cnt);
            dispatch_async(dispatch_get_main_queue(), ^{
                [bSelf reloadView];
            });
        }
    }
     ];
}
-(void)readPhotos{
    if (self.group) {
        [self readPhotoWithGroup:self.group];
    }else{
        __weak typeof(self)bSelf = self;
        
        [[ALAssetsLibrary sharedAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            LOG_D(@"group ::%@",group);
            [bSelf readPhotoWithGroup:group];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}
-(void)reloadData{
    [mediaArray removeAllObjects];
    
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *nameStr = [dic objectForKey:@"CFBundleName"];
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        //无权限
        if (self.noReadAuthorizationHandle) {
            self.noReadAuthorizationHandle();
        }else{
            NSString *tips = [NSString stringWithFormat:@"请在iPhone的“设置——隐私——照片”选项中,允许 %@ 访问你的手机相册",nameStr];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:tips delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        __weak typeof(self)bSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [bSelf readPhotos];
        });
    }
    
}
-(void)reloadView{
    QMLog(@"mediaArray.count:%d",mediaArray.count);
    [cntView reloadData];
    [cntView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self refDoneTitle];
}
-(void)refDoneTitle{
    NSString *title = [NSString stringWithFormat:@"%@(%d/%d)",self.doneTitle,(int)selectAssetArr.count,self.limit];
    UIFont *doneFont = self.doneFont?self.doneFont:[UIFont systemFontOfSize:18];
    float t_w = [title sizeWithAttributes:@{NSFontAttributeName:doneFont}].width;
    [doneBut setTitle:title forState:UIControlStateNormal];
    doneBut.titleEdgeInsets = UIEdgeInsetsMake(0, (100 - t_w), 0, 0);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rowCntInSection;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int index = (int)(indexPath.section*self.rowCntInSection+indexPath.row);
    if (index<mediaArray.count) {
        
        NSDictionary *result = [mediaArray objectAtIndex:index];
        ALAsset *asset = [result objectForKey:@"asset"];
        if (self.shouldSelect) {
            if (!self.shouldSelect(asset)) {
                return;
            }
        }
        
        int selectedCnt  = (int)selectAssetArr.count;
        BOOL selected = [self didSelectAsset:asset];
        if (!selected&&selectedCnt>self.limit-1) {
            if (self.outLimit) {
                self.outLimit();
            }
            return;
        }
        
        
        selected?[self deseleAsset:asset]:[self selectAsset:asset];
        selected = !selected;
        
        QMLPhotoCollectionCell *cell = (QMLPhotoCollectionCell*)[cntView cellForItemAtIndexPath:indexPath];
        cell.tintImage = selected?selectImg:defaultImg;
        
        
        [self refDoneTitle];
        
        if (self.sourceType == UBCPhotoBrowserSourceTypeVideo) {
            [self doneBtnPressed];
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    QMLPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    int index = (int)(indexPath.section*self.rowCntInSection+indexPath.row);
    if (index<mediaArray.count) {
        NSDictionary *result = [mediaArray objectAtIndex:index];
        ALAsset *asset = [result objectForKey:@"asset"];
        cell.image = [UIImage imageWithCGImage:asset.thumbnail];
        BOOL selected = [self didSelectAsset:asset];
        cell.tintImage = selected?selectImg:defaultImg;
        if (self.sourceType==UBCPhotoBrowserSourceTypeVideo) {
            [cell makeTintImgCenter];
        }
        
    }else{
        cell.image = nil;
        cell.tintImage = nil;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    int cnt = (int)mediaArray.count;
    return (cnt%self.rowCntInSection==0)?(cnt/self.rowCntInSection):(cnt/self.rowCntInSection+1);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(i_w, i_w);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 0, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
@end
