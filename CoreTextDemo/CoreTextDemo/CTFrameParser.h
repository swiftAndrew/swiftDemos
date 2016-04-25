//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

@interface CTFrameParser : NSObject
+(NSDictionary*)attributesWithConfig:(CTFrameParserConfig *)config;
+(CoreTextData *)pareContent:(NSString *)content config:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content
                                  config:(CTFrameParserConfig*)config;

+(CoreTextData*)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;
@end
