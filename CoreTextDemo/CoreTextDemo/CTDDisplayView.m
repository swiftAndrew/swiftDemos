//
//  CTDDisplayView.m
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "CTDDisplayView.h"
#import <CoreText/CoreText.h>

@implementation CTDDisplayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    //步骤一
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetRGBFillColor(context, 0.3, 0.4, 0.3, 1);
    
    //步骤3
    CGMutablePathRef path=CGPathCreateMutable();
    //CGPathAddRect(path, NULL, self.bounds);
    
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    NSString *str=@"使用CGContextTranslateCTM和CGContextScaleCTM真不容易，数学不好的哥们头的晕，比如我就是 下面的代码是用来类似做网页点击放大的效果，setTouchPoint是通过touchedmove去调用更新touchpoint点，调整放大镜的center的位置，而放大的效果则在下面drawRect里，而核心就在于如何在矩阵中变化，比如平移，旋转，scale缩放使用CGContextTranslateCTM和CGContextScaleCTM真不容易，数学不好的哥们头的晕，比如我就是 下面的代码是用来类似做网页点击放大的效果，setTouchPoint是通过touchedmove去调用更新touchpoint点，调整放大镜的center的位置，而放大的效果则在下面drawRect里，而核心就在于如何在矩阵中变化，比如平移，旋转，scale缩放使用CGContextTranslateCTM和CGContextScaleCTM真不容易，数学不好的哥们头的晕，比如我就是 下面的代码是用来类似做网页点击放大的效果，setTouchPoint是通过touchedmove去调用更新touchpoint点，调整放大镜的center的位置，而放大的效果则在下面drawRect里，而核心就在于如何在矩阵中变化，比如平移，旋转，scale缩放";
    
    //步骤4
    NSAttributedString *attString=[[NSAttributedString alloc]initWithString:str];
    CTFramesetterRef frameSetter=CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame=CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attString length]), path, NULL);
    
    //步骤5
    CTFrameDraw(frame, context);
    
    //步骤6
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
    
    
}


@end
