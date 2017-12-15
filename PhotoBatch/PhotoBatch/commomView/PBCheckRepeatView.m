//
//  PBCheckRepeatView.m
//  PhotoBatch
//
//  Created by qianjn on 2017/12/11.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "PBCheckRepeatView.h"
#import "PBRepeatImageCell.h"
@interface PBCheckRepeatView()

@property (nonatomic, strong) NSTextField *titlelabel;
@property (nonatomic, strong) UIScrollView *scrolowView;
@property (nonatomic, strong) NSButton    *comfirm;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *currentShowCells;
@end

@implementation PBCheckRepeatView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setWantsLayer:YES];
        [self buildUI];
        _currentShowCells = [NSMutableArray new];
    }
    return self;
}


- (void)buildUI
{
    self.layer.borderColor = [NSColor grayColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.backgroundColor = [NSColor colorWithRGB:0x242424 alpha:0.2].CGColor;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    [self setNeedsDisplay:YES];
    
    
    
    self.titlelabel = [[NSTextField alloc] init];
    self.titlelabel.stringValue = @"选择需要保留的图片";
    self.titlelabel.enabled = NO;
    self.titlelabel.font = FMFont(15);
    [self.titlelabel sizeToFit];
    [self addSubview:self.titlelabel];
    
    self.scrolowView = [[UIScrollView alloc] init];
    [self.scrolowView setWantsLayer:YES];
    self.scrolowView.layer.backgroundColor = [NSColor colorWithRGB:0xffffff alpha:1].CGColor;
    [self addSubview:self.scrolowView];
    
    _comfirm = [[NSButton alloc] init];
    [_comfirm setTitle:@"确定"];
    [_comfirm setTarget:self];
    [_comfirm setAction:@selector(comfirmAction)];
    [self addSubview:_comfirm];
    
    
    
}

- (void)viewDidMoveToSuperview
{
    [self autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(0, 150, 0, 0) excludingEdge:ALEdgeRight]; // 让右侧约束无效
    [self autoSetDimension:ALDimensionWidth toSize:300]; // 自己再添加个宽度约束正好四个
    
    [self.titlelabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titlelabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.titlelabel autoSetDimensionsToSize:self.titlelabel.bounds.size];
    
    [self.scrolowView autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(50, 0, 60, 0)];
    [self.scrolowView setHasVerticalScroller:YES];
    
    [_comfirm autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop]; // 让右侧约束无效
    [_comfirm autoSetDimension:ALDimensionHeight toSize:50]; // 自己再添加个宽度约束正好四个
    
}


- (void)buildUIWithImageArr:(NSArray *)images
{
    
    self.images = [NSMutableArray arrayWithArray:images];
    NSArray *firstGroup = images.firstObject;
    [self showRepeatImages:firstGroup];

}

- (void)comfirmAction
{
    for (PBRepeatImageCell *cell in _currentShowCells) {
        if (!cell.isSesected) {
            [XCFileManager removeItemAtPath:cell.imagePah];
            [cell removeFromSuperview];
        }
    }
    
    if (self.images.count > 0) {
        [self showRepeatImages:self.images.firstObject];
    } else {
        self.hidden = YES;
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"处理完成"];
        [alert setInformativeText:[NSString stringWithFormat:@"文件删除成功"]];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        }];
    }
}


- (void)showRepeatImages:(NSArray *)repeatImages
{
    [_currentShowCells removeAllObjects];
    XCFlipView *docuView = [[XCFlipView alloc] init];
    CGFloat tempHeight = 0;
    for (NSString *filepath in repeatImages) {
        PBRepeatImageCell *cell = [[PBRepeatImageCell alloc] initWithfilePath:filepath with:self.width];
        cell.frame = CGRectMake(0, tempHeight, cell.width, cell.height);
        [docuView addSubview:cell];
        [_currentShowCells addObject:cell];
        tempHeight += (cell.height + 10);
    }
    
    
    docuView.frame = CGRectMake(0, 0, self.width, tempHeight);
    [self.scrolowView setDocumentView:docuView];
    [self.images removeObjectAtIndex:0];
}



@end
