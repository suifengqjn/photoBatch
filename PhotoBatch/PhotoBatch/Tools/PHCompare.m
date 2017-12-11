//
//  PHCompare.m
//  PhotoBatch
//
//  Created by qianjn on 2017/12/7.
//  Copyright © 2017年 SF. All rights reserved.
//

#import "PHCompare.h"
#define ImgBaseSize 8


@interface PHCompare()

@property (nonatomic,assign) Similarity similarity;
@property (nonatomic,strong) NSImage *imga;
@property (nonatomic,strong) NSImage *imgb;

@end



@implementation PHCompare

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imga = [[NSImage alloc]init];
        self.imgb = [[NSImage alloc]init];
    }
    return self;
}
- (void)setImgWithImgA:(NSImage*)imgA ImgB:(NSImage*)imgB
{
    _imga = imgA;
    _imgb = imgB;
}

- (Similarity)getSimilarityValue
{
    return [self getSimilarityValueByCompare];
}
+ (Similarity)getSimilarityValueWithImgA:(NSImage *)imga ImgB:(NSImage *)imgb
{
    PHCompare * getSimilarity = [[PHCompare alloc]init];
    [getSimilarity setImgWithImgA:imga ImgB:imgb];
    return [getSimilarity getSimilarityValue];
}
- (Similarity)getSimilarityValueByCompare
{
    int cursize = ImgBaseSize;
    int ArrSize = cursize * cursize + 1,a[ArrSize],b[ArrSize],i,j,grey,sum = 0;
    CGSize size = {cursize,cursize};
    NSImage * imga = [self reSizeImage:self.imga toSize:size];
    NSImage * imgb = [self reSizeImage:self.imgb toSize:size];
    if (!imga || !imgb) {
        return 0;
    }
    
    a[ArrSize] = 0;
    b[ArrSize] = 0;
    CGPoint point;
    for (i = 0 ; i < cursize; i++) {//计算a的灰度
        for (j = 0; j < cursize; j++) {
            point.x = i;
            point.y = j;
            grey = ToGrey([self NSColorToRGB:[self colorAtPixel:point img:imga]]);
            a[cursize * i + j] = grey;
            a[ArrSize] += grey;
        }
    }
    a[ArrSize] /= (ArrSize - 1);//灰度平均值
    for (i = 0 ; i < cursize; i++) {//计算b的灰度
        for (j = 0; j < cursize; j++) {
            point.x = i;
            point.y = j;
            grey = ToGrey([self NSColorToRGB:[self colorAtPixel:point img:imgb]]);
            b[cursize * i + j] = grey;
            b[ArrSize] += grey;
        }
    }
    b[ArrSize] /= (ArrSize - 1);//灰度平均值
    for (i = 0 ; i < ArrSize ; i++)//灰度分布计算
    {
        a[i] = (a[i] < a[ArrSize] ? 0 : 1);
        b[i] = (b[i] < b[ArrSize] ? 0 : 1);
    }
    ArrSize -= 1;
    for (i = 0 ; i < ArrSize ; i++)
    {
        sum += (a[i] == b[i] ? 1 : 0);
    }
    
    return sum * 1.0 / ArrSize;
}

- (NSImage *)reSizeImage:(NSImage *)image toSize:(CGSize)reSize
{
    NSImage *sourceImage = image;
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: reSize];
        [smallImage lockFocus];
        [sourceImage setSize: reSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, reSize.width, reSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

unsigned int ToGrey(unsigned int rgb)
{
    unsigned int blue   = (rgb & 0x000000FF) >> 0;
    unsigned int green  = (rgb & 0x0000FF00) >> 8;
    unsigned int red    = (rgb & 0x00FF0000) >> 16;
    return ( red*38 +  green * 75 +  blue * 15 )>>7;
}

- (unsigned int)NSColorToRGB:(NSColor*)color
{
    unsigned int RGB,R,G,B;
    RGB = R = G = B = 0x00000000;
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    R = r * 256 ;
    G = g * 256 ;
    B = b * 256 ;
    RGB = (R << 16) | (G << 8) | B ;
    return RGB;
}

- (NSColor *)colorAtPixel:(CGPoint)point img:(NSImage*)img{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, img.size.width, img.size.height), point)) { return nil; }
    
    NSInteger   pointX  = trunc(point.x);
    NSInteger   pointY  = trunc(point.y);
    
    CGImageSourceRef source;
    source = CGImageSourceCreateWithData((CFDataRef)[img TIFFRepresentation], NULL);
    CGImageRef  cgImage =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    NSUInteger  width   = img.size.width;
    NSUInteger  height  = img.size.height;
    int bytesPerPixel   = 4;
    int bytesPerRow     = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [NSColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
