//
//  ViewController.h
//  PhotoBatch
//
//  Created by qianjn on 2017/11/24.
//  Copyright © 2017年 SF. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>


@class PBReNameView;

@interface ViewController : NSViewController

@property (nonatomic, strong, readonly) PBReNameView *reNameView;

@property (nonatomic, strong, readonly) NSArray *folderPaths; //选择的文件路径

@property (weak) IBOutlet NSTextField *dealingLabel;

@end

