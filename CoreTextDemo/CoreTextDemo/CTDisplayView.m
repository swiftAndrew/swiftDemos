//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "CTDisplayView.h"

@implementation CTDisplayView
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    if(self.data){
        CTFrameDraw(self.data.ctframe, context);
    }
}
@end
