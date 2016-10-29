//
//  QMLAlertAction.m
//  USENSE
//
//  Created by Myron on 16/2/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLKit.h"
#import "QMLAlertAction.h"
@interface QMLAlertAction ()
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *titleFont;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;
@end
@implementation QMLAlertAction
-(void)setupDefineValues{
    [super setupDefineValues];
    self.titleFont = [UIFont systemFontOfSize:18];
    self.titleColor = COLOR_WITH_RGB(21, 23, 28);
}
-(id)initWithTitle:(NSString *)title handle:(QMLAlertHandle)handle{
    if (![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    [self setupDefineValues];
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{NSFontAttributeName:self.titleFont,
                                                                                NSForegroundColorAttributeName:self.titleColor
                                                                                }];
    return [self initWithAttributedTitle:attTitle handle:handle];
}
-(id)initWithAttributedTitle:(NSAttributedString *)attributedTitle handle:(QMLAlertHandle)handle{
    if (self = [super init]) {
        _title = attributedTitle;
        _handle = handle;
    }
    return self;
}
- (void)dealloc
{
    DEALLOC_PRINT;
}
@end
