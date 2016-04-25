//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "CTFrameParserConfig.h"
#import "GlobalConfig.h"

@implementation CTFrameParserConfig
-(id)init{
    self=[super init];
    if(self){
        _widht=200;
        _fontSize=16;
        _lineSpace=8;
        _textColor=RGB(108, 108, 108);
    }
    return self;
}
@end
