//
//  ViewController.m
//  PhotoBatch
//
//  Created by qianjn on 2017/11/24.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "ViewController.h"
#import "PBReNameView.h"
#import "XCFlipView.h"
#import "PBDragView.h"
#import "PBCheckRepeatView.h"
#import "PHCompare.h"
typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeReName = 1,
    ActionTypeCheckRepeat,
};


@interface ViewController()<PBDragViewDelegate>


@property (nonatomic, assign) ActionType actionType;

@property (nonatomic, strong, readwrite) PBReNameView *reNameView;
@property (nonatomic, strong, readwrite) PBCheckRepeatView *checkRepeatView;

@property (nonatomic, strong, readwrite) NSArray *folderPaths; //选择的文件路径

@property (weak) IBOutlet PBDragView *dragView;

@property (weak) IBOutlet XCFlipView *flipContetntView;

@property (weak) IBOutlet NSButton *reNameCheckBtn;

@property (weak) IBOutlet NSButton *CheckRepeatBtn;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dragView.delegate = self;
    _reNameView = [[PBReNameView alloc] init];
    _reNameView.hidden = YES;
    [_flipContetntView addSubview:_reNameView];
    
    
    _checkRepeatView = [[PBCheckRepeatView alloc] init];
    _checkRepeatView.hidden = YES;
    [_flipContetntView addSubview:_checkRepeatView];
    
    
    
    
    [_reNameCheckBtn setAction:@selector(reNameCheckBtnAction:)];
    [_CheckRepeatBtn setAction:@selector(checkRepeatAction:)];
    
}

- (IBAction)addFile:(NSButton *)sender {
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];
    [openPanel setCanChooseDirectories:YES]; //设置允许打开文件夹
    [openPanel setAllowsMultipleSelection:YES]; // 会否允许打开多个目录
    [openPanel setCanChooseFiles:YES];  //设置允许打开文件
    [openPanel setCanCreateDirectories:YES]; // 允许新建文件夹
    [openPanel setCanDownloadUbiquitousContents:NO]; //是否处理还未下载成功的文档
    [openPanel setCanResolveUbiquitousConflicts:NO]; //是否处理有冲突的文档
    openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"jpg", @"doc",@"txt",@"jpeg",@"png",@"tiff", nil]; //设置允许打开的文件类型
    __weak __typeof(self)weakSelf = self;
    [openPanel beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:^(NSModalResponse result) {
        
        NSArray *filePaths = [openPanel URLs];
        if (filePaths.count > 0) {
            [weakSelf dealFiles:filePaths];
        }
        NSLog(@"-----%@", filePaths);
        
    }];
    
    
}


#pragma mark - action

- (void)dealFiles:(NSArray *)filepaths
{
    self.dealingLabel.stringValue = [filepaths.firstObject description];
    
    NSMutableArray *arr = [NSMutableArray new];
    // 对文件夹路径进行处理
    for (NSString *path in filepaths) {
        if ([[path description] hasPrefix:@"file:///"]) {
            NSString *newpath = [[path description] substringFromIndex:7];
            if ([newpath hasSuffix:@"/"]) {
                newpath  = [newpath substringToIndex:newpath.length - 1];
            }
            [arr addObject:newpath];
            
        } else {
            if ([[path description] hasSuffix:@"/"]) {
                NSString *tempStr = [path description];
                [arr addObject:[tempStr substringToIndex:tempStr.length - 1]];
            } else {
                [arr addObject:[path description]];
            }
            
        }
    }
    
    self.folderPaths = filepaths;
    
    NSMutableArray *allFiles = [NSMutableArray new];
    for (NSString *docuPath in self.folderPaths) { // 遍历所有文件夹 获取所有文件个数
        NSArray *files = [XCFileManager listFilesInDirectoryAtPath:docuPath deep:NO];//这里遍历得到的只是文件名
        [allFiles addObjectsFromArray:files];
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"文件获取成功"];
    [alert setInformativeText:[NSString stringWithFormat:@"文件总数：%ld 个", allFiles.count]];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
    }];
}

- (void)reNameCheckBtnAction:(NSButton *)sender {
    
    if (sender.state == 1) {
        [self clearActionView];
        _reNameView.hidden = NO;
        sender.state = 1;
        _actionType = ActionTypeReName;
    } else {
        _reNameView.hidden = YES;
        [self initActionType];
    }
    
}

- (void)checkRepeatAction:(NSButton *)sender
{
    if (sender.state == 1) {
        [self clearActionView];
        _checkRepeatView.hidden = NO;
        sender.state = 1;
        _actionType = ActionTypeCheckRepeat;
    } else {
        _checkRepeatView.hidden = YES;
        [self initActionType];
    }
}


- (void)clearActionView
{
    _reNameCheckBtn.state = 0;
    _reNameView.hidden = YES;
    
    _CheckRepeatBtn.state = 0;
    _checkRepeatView.hidden = YES;
    
}

- (void)initActionType
{
    _actionType = 0;
}


#pragma mark -- start Action
- (IBAction)StartAction:(NSButton *)sender {
    
    switch (_actionType) {
        case ActionTypeReName:
            [self reNameAction];
            break;
        case ActionTypeCheckRepeat:
            [self checkRepeatAction];
            break;
        default:
            break;
    }

}

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


- (void)checkRepeatAction
{
    NSMutableArray *allFiles = [NSMutableArray new];
    for (NSString *docuPath in self.folderPaths) {
        NSArray *files = [XCFileManager listFilesInDirectoryAtPath:docuPath deep:NO];//这里遍历得到的只是文件名
        for (NSString *filename in files) {
            if (![filename hasSuffix:@"Store"]) {
                [allFiles addObject:[NSString stringWithFormat:@"%@/%@", docuPath, filename]];
            }
        }
    }
    if (allFiles.count == 0) {
        return;
    }
    NSMutableArray *totalArr = [NSMutableArray array];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSString *filePath in allFiles) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dealingLabel.stringValue = [NSString stringWithFormat:@"处理文件：%@", filePath];
            });
            if (totalArr.count == 0) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:filePath];
                [totalArr addObject:arr];
            } else {
                
                NSInteger groupCount = [[totalArr mutableCopy] count];
                for (int i = 0; i < groupCount; i++) {
                    NSMutableArray *arr = totalArr[i];
                    NSImage *imagea = [[NSImage alloc] initWithContentsOfFile:arr.firstObject];
                    NSImage *imageb = [[NSImage alloc] initWithContentsOfFile:filePath];
                    Similarity simi = [PHCompare getSimilarityValueWithImgA:imagea ImgB:imageb];
                    if (simi >= 0.9) { //相似度比较接近
                        [arr addObject:filePath];
                        break;
                    } else {
                        if (i == [[totalArr mutableCopy] count] - 1) {  //已经遍历到最后一组，还没有找到相似图片，新建一组
                            NSMutableArray *arr = [NSMutableArray array];
                            [arr addObject:filePath];
                            @synchronized(totalArr) {
                                [totalArr addObject:arr];
                            }
                            break;
                        }
                    }
                }
                
                
            }
        }
        
        NSMutableArray *repeatArr = [NSMutableArray new];
        for (NSArray *arr in totalArr) {
            if (arr.count > 1) {
                [repeatArr addObject:arr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dealingLabel.stringValue = [NSString stringWithFormat:@"处理完成"];
            [self.checkRepeatView buildUIWithImageArr:repeatArr];
        });
        
    });

}

#pragma mark - PBDragViewDelegate

- (void)dragFileComplete:(NSArray *)filepaths
{
    if (filepaths.count > 0) {
        [self dealFiles:filepaths];
    }
    
}

- (void)dragExit
{
    
}


@end
