//
//  PBReNameView.m
//  PhotoBatch
//
//  Created by qianjn on 2017/11/29.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "PBReNameView.h"


@interface PBReNameView()

@property (nonatomic, strong) NSTextField *useTip;
@property (nonatomic, strong) NSTextField *prefixTip;
@property (nonatomic, strong, readwrite) NSTextField *prefixInput;  //前缀
@property (nonatomic, strong) NSTextField *suffixTip;
@property (nonatomic, strong, readwrite) NSTextField *suffixInput; // 后缀
@property (nonatomic, strong, readwrite) NSButton *checkSaveBtn; // 是否保留原文件


@end

@implementation PBReNameView

- (BOOL)isFlipped
{
    return YES;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setWantsLayer:YES];
        [self buildUI];
        
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
    
    
    _useTip = [[NSTextField alloc] init];
    _useTip.enabled = NO;
    _useTip.stringValue = @"文件批量重命名, 命名格式'前缀_i', i 以1，2一直递增";
    _useTip.textColor = [NSColor colorWithRGB:0x242424 alpha:1];
    _useTip.layer.backgroundColor = [NSColor colorWithRGB:0x242424 alpha:0.2].CGColor;
    [_useTip setWantsLayer:YES];
    [_useTip setNeedsDisplay:YES];
    [_useTip sizeToFit];
    [self addSubview:_useTip];
    [_useTip autoAlignAxisToSuperviewAxis:ALAxisVertical]; // 垂直对齐
    [_useTip autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.f]; // 距离左边20
    [_useTip autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:20]; // 相对于self  自己顶部  与 self 顶部 距离 100
    [_useTip autoSetDimensionsToSize:_useTip.bounds.size];
    
    
    _prefixTip = [[NSTextField alloc] init];
    _prefixTip.enabled = NO;
    _prefixTip.stringValue = @"文件名前缀，不填默认为'img'";
    _prefixTip.textColor = [NSColor colorWithRGB:0x242424 alpha:1];
    [_prefixTip sizeToFit];
    [self addSubview:_prefixTip];
    [_prefixTip autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_useTip withOffset:30]; // 相对于_useTip  自己顶部  与 _useTip 顶部 距离 30
    [_prefixTip autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_useTip]; // 相对于_useTip 左对齐
    [_prefixTip autoSetDimensionsToSize:_prefixTip.bounds.size];
    
    _prefixInput = [[NSTextField alloc] init];
    _prefixInput.enabled = YES;
    _prefixInput.placeholderString = @"输入文件名前缀";
    _prefixInput.textColor = [NSColor colorWithRGB:0x242424 alpha:1];
    [_prefixInput sizeToFit];
    [self addSubview:_prefixInput];
    [_prefixInput autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_prefixTip withOffset:20];
    [_prefixInput autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_prefixTip];
    [_prefixInput autoSetDimensionsToSize:CGSizeMake(200, _prefixInput.bounds.size.height)];
    
    
    _suffixTip = [[NSTextField alloc] init];
    _suffixTip.enabled = NO;
    _suffixTip.stringValue = @"文件名格式，不填默认为原格式";
    _suffixTip.textColor = [NSColor colorWithRGB:0x242424 alpha:1];
    [_suffixTip sizeToFit];
    [self addSubview:_suffixTip];
    [_suffixTip autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_prefixInput withOffset:30]; // 相对于_useTip  自己顶部  与 _useTip 顶部 距离 30
    [_suffixTip autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_useTip]; // 相对于_useTip 左对齐
    [_suffixTip autoSetDimensionsToSize:_suffixTip.bounds.size];
    
    _suffixInput = [[NSTextField alloc] init];
    _suffixInput.enabled = YES;
    _suffixInput.placeholderString = @"输入文件名格式";
    _suffixInput.textColor = [NSColor colorWithRGB:0x242424 alpha:1];
    [_suffixInput sizeToFit];
    [self addSubview:_suffixInput];
    [_suffixInput autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_suffixTip withOffset:20];
    [_suffixInput autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_suffixTip];
    [_suffixInput autoSetDimensionsToSize:CGSizeMake(200, _suffixInput.bounds.size.height)];
    
    
    _checkSaveBtn = [[NSButton alloc] init];
    [_checkSaveBtn setTitle:@"是否保留原文件"];
    [_checkSaveBtn setTarget:self];
    [_checkSaveBtn setAction:@selector(checkAction)];
    _checkSaveBtn.font = FMFont(15);
    [_checkSaveBtn setButtonType:NSButtonTypeSwitch];
    [_checkSaveBtn sizeToFit];
    [self addSubview:_checkSaveBtn];
    [_checkSaveBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_suffixInput withOffset:30];
    [_checkSaveBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_suffixInput];
    [_checkSaveBtn autoSetDimensionsToSize:_checkSaveBtn.bounds.size];
    
}

- (void)checkAction
{
    
}

- (void)viewDidMoveToSuperview
{
    [self autoPinEdgesToSuperviewEdgesWithInsets:NSEdgeInsetsMake(0, 150, 0, 0) excludingEdge:ALEdgeRight]; // 让右侧约束无效
    [self autoSetDimension:ALDimensionWidth toSize:300]; // 自己再添加个宽度约束正好四个
}


@end
