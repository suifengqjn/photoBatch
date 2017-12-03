//
//  PBReNameView.h
//  PhotoBatch
//
//  Created by qianjn on 2017/11/29.
//  Copyright © 2017年 SF. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XCFlipView.h"
@interface PBReNameView : NSView

@property (nonatomic, strong, readonly) NSTextField *prefixInput;  //前缀
@property (nonatomic, strong, readonly) NSTextField *suffixInput; // 后缀
@property (nonatomic, strong, readonly) NSButton *checkSaveBtn; // 是否保留原文件
@end
