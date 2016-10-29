//
//  QMLAlertView.m
//  USENSE
//
//  Created by 马小云 on 16/1/26.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLAlertView.h"
#import "QMLTouchView.h"
#import "QMLAlertManager.h"
#import "QMLKit.h"

#define QMLALERT_VIEW_LINE_WIDTH 0.5
#define QMLALERT_VIEW_HANDLE_ITEM_HEIGHT 44

@interface QMLAlertView ()
{
    QMLView *cntView;
    UITextView *cntTextView;
    UITextView *titleTextView;
    QMLEdge content_edge;
    QMLEdge title_edge;
}

@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *contentFont;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *contentColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *titleFont;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;

@property (nonatomic,QML_DEFINE_PRO_RETAIN)NSAttributedString *attributedContent;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)NSAttributedString *attributedTitle;
@property (nonatomic,assign)BOOL active;


@property (nonatomic,QML_DEFINE_PRO_RETAIN)NSArray<QMLAlertAction *> *actions;
@end

@implementation QMLAlertView
- (void)dealloc
{
    DEALLOC_PRINT;
}
-(void)setupDefineValues{
    [super setupDefineValues];
    self.contentFont = [UIFont systemFontOfSize:16];
    self.titleFont = [UIFont systemFontOfSize:18];
    self.titleColor = COLOR_WITH_RGB(21, 23, 28);
    self.contentColor = COLOR_WITH_RGB(21, 23, 28);
    self.contentBgColor = COLOR_WITH_RGB(245, 250, 249);
    self.position = QMLPositionCenter;
    
    self.separatorType = QMLSeparatorTypeLine;
    
    content_edge.left = 20;
    content_edge.top = 15;
    content_edge.right = 20;
    content_edge.bottom = 15;
    
    title_edge.left = 20;
    title_edge.top = 5;
    title_edge.right = 20;
    title_edge.bottom = 0;
    
    self.contentWidth = 300;
    self.contentRadius = 10;
}
-(QMLEdge *)contentEdge{
    return &content_edge;
}
-(QMLEdge *)titleEdge{
    return &title_edge;
}
-(BOOL)autoDismiss{
    return self.actions.count==0;
}
-(id)initWithTitle:(NSString *)title{
    return [self initWithTitle:title msg:nil actions:nil];
}
-(id)initWithMsg:(NSString *)msg{
    return [self initWithTitle:nil msg:msg actions:nil];
}
-(id)initWithTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<QMLAlertAction *> *)actions{
    if (self = [super init]) {
        if ([title isKindOfClass:[NSString class]]) {
            self.attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{NSFontAttributeName:self.titleFont,
                                                                                NSForegroundColorAttributeName:self.titleColor
                                                                                                 }];
        }
        if ([msg isKindOfClass:[NSString class]]) {
//            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//            style.lineSpacing = 5;
//            [cnt addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, cnt.string.length)];
//            long number = 1.5;
//            
//            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
//            [cnt addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,cnt.string.length)];
            self.attributedContent = [[NSAttributedString alloc] initWithString:msg
                                                                   attributes:@{NSFontAttributeName:self.contentFont,
                                                                                NSForegroundColorAttributeName:self.contentColor
                                                                                }];
        }else{
            return nil;
        }
        self.actions = actions;
    }
    return self;
}
-(QMLView*)draw{
    if (!cntView) {
        cntView = [[QMLView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, 10)];
        cntView.clipsToBounds = YES;
    }
    cntView.backgroundColor = self.contentBgColor;
    cntView.layer.cornerRadius = self.contentRadius;
    cntView.layer.borderColor = self.contentBorderColor.CGColor;
    cntView.layer.borderWidth = self.contentBorderWidth;
    
    CGFloat h = 0;
    if (self.attributedTitle) {
        h += self.titleEdge->top;
        float t_x = self.titleEdge->left;
        float t_w = self.contentWidth - self.titleEdge->left - self.titleEdge->right;
        if (!titleTextView ) {
            titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(t_x, h, t_w, 10)];
            titleTextView.userInteractionEnabled = NO;
            titleTextView.textContainer.lineFragmentPadding = 0;
            titleTextView.backgroundColor = [UIColor clearColor];
            [cntView addSubview:titleTextView];
        }
        titleTextView.attributedText = self.attributedTitle;
        titleTextView.textAlignment = NSTextAlignmentCenter;
        float t_h = [titleTextView sizeThatFits:CGSizeMake(t_w, CGFLOAT_MAX)].height;
        titleTextView.frame = CGRectMake(t_x, h, t_w, t_h);
        
        h += t_h;
        h += self.titleEdge->bottom;
    }else{
        [titleTextView removeFromSuperview];
        titleTextView = nil;
    }
    
    h += self.contentEdge->top;
    float c_x = self.contentEdge->left;
    float c_w = self.contentWidth - self.contentEdge->left - self.contentEdge->right;
    
    if (!cntTextView) {
        cntTextView = [[UITextView alloc] initWithFrame:CGRectMake(c_x, h, c_w, 10)];
        cntTextView.userInteractionEnabled = NO;
        cntTextView.textContainer.lineFragmentPadding = 0;
        cntTextView.backgroundColor = [UIColor clearColor];
        [cntView addSubview:cntTextView];
    }
    cntTextView.attributedText = self.attributedContent;
    cntTextView.textAlignment = NSTextAlignmentCenter;
    float c_h = [cntTextView sizeThatFits:CGSizeMake(c_w, CGFLOAT_MAX)].height;
    cntTextView.frame = CGRectMake(c_x, h, c_w, c_h);
    
    h += c_h;
    h += self.contentEdge->bottom;
    
    
    int cnt = (int)self.actions.count;
    if (cnt>0) {
        BOOL twoInRow = YES;
        if (cnt==2) {
            for (QMLAlertAction *action in self.actions) {
                NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
                CGRect rect = [action.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, QMLALERT_VIEW_HANDLE_ITEM_HEIGHT) options:options context:nil];
                float w = (self.contentWidth-QMLALERT_VIEW_LINE_WIDTH)/2;
                if (rect.size.width>w) {
                    twoInRow = NO;
                    break;
                }
            }
        }else{
            twoInRow = NO;
        }
        if (twoInRow){
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, h, self.contentWidth, QMLALERT_VIEW_LINE_WIDTH)];
                lineView.backgroundColor = COLOR_WITH_RGB(200, 200, 200);
                [cntView addSubview:lineView];
                h += lineView.frame.size.height;
            }
            
            float w = (self.contentWidth-QMLALERT_VIEW_LINE_WIDTH)/2;
            for (int i=0; i<cnt; i++) {
                QMLTouchView *touchView = [self createTouchViewWithFrame:CGRectMake((w+QMLALERT_VIEW_LINE_WIDTH)*i, h, w, QMLALERT_VIEW_HANDLE_ITEM_HEIGHT)];
                touchView.tag = i;
                [cntView addSubview:touchView];
                
                QMLAlertAction *action = self.actions[i];
                UILabel *la = [[UILabel alloc] initWithFrame:touchView.bounds];
                la.backgroundColor = [UIColor clearColor];
                la.attributedText = action.title;
                la.textAlignment = NSTextAlignmentCenter;
                [touchView addSubview:la];
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(w+QMLALERT_VIEW_LINE_WIDTH, h, QMLALERT_VIEW_LINE_WIDTH, QMLALERT_VIEW_HANDLE_ITEM_HEIGHT)];
            lineView.backgroundColor = COLOR_WITH_RGB(200, 200, 200);
            [cntView addSubview:lineView];
            
            h += QMLALERT_VIEW_HANDLE_ITEM_HEIGHT;
            
        }else{
            for (int i=0; i<cnt; i++) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, h, self.contentWidth, QMLALERT_VIEW_LINE_WIDTH)];
                lineView.backgroundColor = COLOR_WITH_RGB(200, 200, 200);
                [cntView addSubview:lineView];
                
                h += lineView.frame.size.height;
                
                QMLTouchView *touchView = [self createTouchViewWithFrame:CGRectMake(0, h, self.contentWidth, QMLALERT_VIEW_HANDLE_ITEM_HEIGHT)];
                touchView.tag = i;
                [cntView addSubview:touchView];
                
                QMLAlertAction *action = self.actions[i];
                
                UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.contentWidth-20, QMLALERT_VIEW_HANDLE_ITEM_HEIGHT)];
                la.backgroundColor = [UIColor clearColor];
                la.attributedText = action.title;
                la.adjustsFontSizeToFitWidth = YES;
                la.textAlignment = NSTextAlignmentCenter;
                [touchView addSubview:la];
                
                
                h += touchView.frame.size.height;
            }
        }
    }
    

    cntView.frame = CGRectMake(0, 0, self.contentWidth, h);
    return cntView;
}
-(QMLTouchView *)createTouchViewWithFrame:(CGRect )rect{
    QMLTouchView *touchView = [[QMLTouchView alloc] initWithFrame:rect];
    touchView.backgroundColor = self.contentBgColor;
    touchView.clipsToBounds = YES;
    
    __weak typeof(self)bSelf = self;
    __weak typeof(touchView)bTouchView = touchView;
    touchView.touchesBegan = ^(NSSet<UITouch *> *touches,UIEvent *event){
        if (bSelf.active) {
            return;
        }
        bTouchView.backgroundColor = COLOR_WITH_RGB(200, 200, 200);
        bSelf.active = YES;
    };
    touchView.touchesEnded = ^(NSSet<UITouch *> *touches,UIEvent *event){
        bTouchView.backgroundColor = COLOR_WITH_RGB(200, 200, 200);
        bSelf.active = NO;
        [bSelf resActionWithIndex:(int)bTouchView.tag];
    };
    touchView.touchesCancelled = touchView.touchesEnded;
    return touchView;
}
-(void)resActionWithIndex:(int)index{
    QMLAlertHandle handle = [self.actions[index] handle];
    if (handle) {
        handle(index);
    }
    [[QMLAlertManager sharedManger] dismissAlert];
}
-(void)show{
    [[QMLAlertManager sharedManger] addAlert:self];
    [[QMLAlertManager sharedManger] showAlert];
}
@end
