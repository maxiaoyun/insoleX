//
//  QMLSegmentControl.m
//  QMLib
//
//  Created by 流云_陌陌 on 14-8-12.
//  Copyright (c) 2014年 流云_陌陌. All rights reserved.
//

#import "QMLSegmentControl.h"
#import "QMLSegItem.h"
#import "QMLLayoutFunction.h"
#define SPAN_TO_BOUNDS 2

@interface QMLSegmentControl()
{
    float itemWidth;
}
@end
@implementation QMLSegmentControl
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    Block_release(_valueChanged);
    [_items release];
    [_font release];
    [_separatorColor release];
    [super dealloc];
#endif
}
-(id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if (self=[super initWithFrame:frame]) {
        self.items=items;
    }
    return self;
}
-(void)setupDefineValues{
    [super setupDefineValues];
    self.imgYOffset = SPAN_TO_BOUNDS;
    self.imgScale = [[UIScreen mainScreen] scale];
    self.font = [UIFont systemFontOfSize:10];
}
-(void)setItems:(NSArray *)items
{
#if __has_feature(objc_arc)
    if (_items != items) {
        _items = items;
    }
#else
    SET_PAR(_items, items);
#endif
    [self createView];
}
-(void)createView
{
    if (self.items.count==0) {
        return;
    }
    itemWidth=(self.frame.size.width - (self.items.count-1)*self.separatorWidth)/self.items.count;
    float height=self.frame.size.height;
    
    float x = 0;
    for (int i=0; i<self.items.count; i++) {
        QMLSegItem *item=[self.items objectAtIndex:i];
        
        float w = item.itemWidth==0?itemWidth:item.itemWidth;
        UIControl *bgView = [[UIControl alloc] initWithFrame:CGRectMake(x+item.xOffset, item.yOffset, w, height)];
        bgView.backgroundColor = item.defaultbgColor;
        bgView.tag = 30+i;
        [self addSubview:bgView];
        [bgView addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (item.title) {
            UILabel *titleLa=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 20)];
            titleLa.text=item.title;
            titleLa.backgroundColor=[UIColor clearColor];
            titleLa.textColor=item.defaultTextColor;
            titleLa.tag=20+i;
            titleLa.textAlignment=NSTextAlignmentCenter;
            titleLa.font=self.font;
            titleLa.center=CGPointMake(bgView.frame.size.width/2, height/2);
            [bgView addSubview:titleLa];
            
            if (item.defaultImage) {
                UIImage *image=item.defaultImage;
                UIImageView *itemImView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width/self.imgScale, image.size.height/self.imgScale)];
                itemImView.image=image;
                itemImView.tag=10+i;
                itemImView.center=CGPointMake(bgView.frame.size.width/2, self.imgYOffset+itemImView.frame.size.height/2);
                [bgView addSubview:itemImView];
                
                titleLa.center=CGPointMake(bgView.frame.size.width/2, height-SPAN_TO_BOUNDS-titleLa.frame.size.height/2);
            }
        }else{
            if (item.defaultImage) {
                UIImage *image=item.defaultImage;
                UIImageView *itemImView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width/self.imgScale, image.size.height/self.imgScale)];
                itemImView.image=image;
                itemImView.tag=10+i;
                itemImView.center=CGPointMake(bgView.frame.size.width/2, height/2);
                [bgView addSubview:itemImView];
            }
        }
        if (i!=self.items.count-1&&self.separatorWidth!=0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x+w, self.separatorSpan, self.separatorWidth, height-2*self.separatorSpan)];
            line.backgroundColor = self.separatorColor?self.separatorColor:[UIColor darkGrayColor];
            line.clipsToBounds = YES;
            line.layer.cornerRadius = self.separatorWidth/2;
            [self addSubview:line];
        }
        
        
        x+= w+self.separatorWidth;
    }
}


-(void)redrawView
{
    
}
-(void)updateTitle:(NSString *)title withIndex:(int)index{
    UIView *bgView = [self viewWithTag:30+index];
    UILabel *titleLa = (UILabel *)[bgView viewWithTag:20+index];
    if ([titleLa isKindOfClass:[UILabel class]]) {
        titleLa.text = title;
    }
}

-(void)clickAction:(UIControl *)control{
    self.selectIndex = (int)control.tag-30;
}
-(void)showIndexWithRes:(BOOL)rep index:(int)selectIndex
{
    if(_selectIndex!=0&&selectIndex == _selectIndex){return;}
    
    UIView *lastBgView = [self viewWithTag:30+_selectIndex];
    UIImageView *lastIm=(UIImageView *)[lastBgView viewWithTag:10+_selectIndex];
    UILabel *lastLa=(UILabel *)[lastBgView viewWithTag:20+_selectIndex];
    QMLSegItem *lastItem=[self.items objectAtIndex:_selectIndex];
    lastIm.image=lastItem.defaultImage;
    lastLa.textColor=lastItem.defaultTextColor;
    lastBgView.backgroundColor = lastItem.defaultbgColor;
    
    
    _selectIndex=selectIndex;
    
    UIView *bgView = [self viewWithTag:30+_selectIndex];
    UIImageView *im=(UIImageView *)[bgView viewWithTag:10+_selectIndex];
    UILabel *la=(UILabel *)[bgView viewWithTag:20+_selectIndex];
    QMLSegItem *item=[self.items objectAtIndex:_selectIndex];
    im.image=item.heightLightImage;
    la.textColor=item.heightLightTextColor;
    bgView.backgroundColor = item.heightLightbgColor;
    
    if (rep&&self.valueChanged) {
        self.valueChanged(_selectIndex);
    }
}
-(void)setSelectIndex:(int)selectIndex
{
    [self showIndexWithRes:YES index:selectIndex];
}

@end
