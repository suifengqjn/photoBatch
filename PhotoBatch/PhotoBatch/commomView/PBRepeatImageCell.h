//
//  PBRepeatImageCell.h
//  PhotoBatch
//
//  Created by qianjn on 2017/12/13.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "XCFlipView.h"

@interface PBRepeatImageCell : XCFlipView

@property (nonatomic, copy) NSString *imagePah;
@property (nonatomic, assign) BOOL   isSesected;

- (instancetype)initWithfilePath:(NSString *)path with:(CGFloat)width;

@end
