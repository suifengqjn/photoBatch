//
//  ViewController+ReName.m
//  PhotoBatch
//
//  Created by qianjn on 2017/12/11.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "ViewController+ReName.h"

@implementation ViewController (ReName)


- (void)reNameAction
{
    NSMutableArray *allFiles = [NSMutableArray new];
    for (NSString *docuPath in self.folderPaths) {
        NSArray *files = [XCFileManager listFilesInDirectoryAtPath:docuPath deep:NO];//这里遍历得到的只是文件名
        for (NSString *filename in files) {
            [allFiles addObject:[NSString stringWithFormat:@"%@/%@", docuPath, filename]];
        }
    }
    if (allFiles.count == 0) {
        return;
    }
    NSString *resultFilePath = [NSString stringWithFormat:@"%@/%@", self.folderPaths.firstObject, @"result"];
    
    NSError *err = nil;
    [XCFileManager createDirectoryAtPath:resultFilePath error:&err];
    NSString *prefixName = self.reNameView.prefixInput.stringValue;
    if (!prefixName || prefixName.length == 0) {
        prefixName = @"img_";
    }
    NSString *suffixName = self.reNameView.suffixInput.stringValue;
    if(!suffixName || suffixName.length == 0) {
        suffixName = @"";
    }
    NSInteger index = 0;
    NSString *suffix = @"";
    for (NSString *path in allFiles) {
        //        // 如果遇到 没有文件名的文件，直接过滤
        if ([path componentsSeparatedByString:@"."].count < 2) {
            continue;
        }
        if (suffixName.length == 0) {
            suffix = [[path componentsSeparatedByString:@"."].lastObject description];
        } else {
            suffix = suffixName;
        }
        self.dealingLabel.stringValue = [path description];
        
        NSString *movePath = [NSString stringWithFormat:@"%@/%@%ld.%@", resultFilePath, prefixName, index,suffix];
        if (self.reNameView.checkSaveBtn.state == 1) {
            [XCFileManager moveItemAtPath:path toPath:movePath overwrite:NO];
        } else {
            [XCFileManager moveItemAtPath:path toPath:movePath overwrite:YES];
        }
        
        index ++;
    }
    
    self.dealingLabel.stringValue = @"处理完成";
}

@end
