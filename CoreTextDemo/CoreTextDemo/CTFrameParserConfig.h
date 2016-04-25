//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTFrameParserConfig : NSObject
@property (nonatomic,assign) CGFloat widht;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *textColor;


@end
