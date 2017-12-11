//
//  PHCompare.h
//  PhotoBatch
//
//  Created by qianjn on 2017/12/7.
//  Copyright © 2017年 SF. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef double Similarity;

@interface PHCompare : NSObject

- (void)setImgWithImgA:(NSImage*)imgA ImgB:(NSImage*)imgB;
- (Similarity)getSimilarityValue;
+ (Similarity)getSimilarityValueWithImgA:(NSImage*)imga ImgB:(NSImage*)imgb;

@end
