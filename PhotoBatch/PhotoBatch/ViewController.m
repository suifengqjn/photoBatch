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
#import "ViewController+ReName.h"


typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeReName = 1,
    ActionTypeCheckRepeat,
};


@interface ViewController()<PBDragViewDelegate>


@property (nonatomic, assign) ActionType actionType;

@property (nonatomic, strong, readwrite) PBReNameView *reNameView;

@property (nonatomic, strong, readwrite) NSArray *folderPaths; //选择的文件路径

@property (weak) IBOutlet PBDragView *dragView;

@property (weak) IBOutlet XCFlipView *flipContetntView;

@property (weak) IBOutlet NSButton *reNameCheckBtn;


@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dragView.delegate = self;
    _reNameView = [[PBReNameView alloc] init];
    _reNameView.hidden = YES;
    [_flipContetntView addSubview:_reNameView];
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

// 开始处理
- (IBAction)StartAction:(NSButton *)sender {
    
    switch (_actionType) {
        case ActionTypeReName:
            [self reNameAction];
            break;
        case ActionTypeCheckRepeat:
             
            break;
        default:
            break;
    }
    
    
    
}

- (IBAction)reNameCheckBtnAction:(NSButton *)sender {
    
    if (sender.state == 1) {
        //[_flipContetntView addSubview:_reNameView];
        _reNameView.hidden = NO;
    } else {
        //[_reNameView removeFromSuperview];
        _reNameView.hidden = YES;
    }
    
}

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
