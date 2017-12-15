//
//  PBRepeatImageCell.m
//  PhotoBatch
//
//  Created by qianjn on 2017/12/13.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "PBRepeatImageCell.h"

@interface PBRepeatImageCell()

@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSButton *checkBn;
@end



@implementation PBRepeatImageCell

- (instancetype)initWithfilePath:(NSString *)path with:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 150)];
    if (self) {
        _imagePah = path;
        [self buidUIWithfilePath:path width:width];
    }
    return self;
}


- (void)buidUIWithfilePath:(NSString *)path width:(CGFloat)width
{
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    CGFloat imageViewWidth = width - 70;
    CGFloat imageViewHeight = [image size].height * imageViewWidth / [image size].width;
    _imageView = [[NSImageView alloc] init];
    _imageView.image = image;
    _imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
    [self addSubview:_imageView];
    
    _checkBn = [[NSButton alloc] init];
    [_checkBn setTarget:self];
    [_checkBn setAction:@selector(checkAction:)];
    [_checkBn setTitle:@"选择  "];
    [_checkBn setButtonType:NSSwitchButton];
    [_checkBn sizeToFit];
    _checkBn.frame = CGRectMake(width - _checkBn.width - 10, (imageViewHeight - _checkBn.height)/2, _checkBn.width, _checkBn.height);
    [self addSubview:_checkBn];
    self.frame = CGRectMake(0, 0, width, imageViewHeight);
    
    
}

- (void)checkAction:(NSButton *)sender
{
    _isSesected = sender.state;
}


@end
