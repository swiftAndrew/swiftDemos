//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject
@property (nonatomic,assign)CTFrameRef ctframe;
@property (nonatomic,assign)CGFloat height;

@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;
@property (strong, nonatomic) NSAttributedString *content;


@end
