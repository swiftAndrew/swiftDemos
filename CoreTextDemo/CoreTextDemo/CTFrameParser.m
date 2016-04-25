//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "CTFrameParser.h"

@implementation CTFrameParser
+(NSDictionary*)attributesWithConfig:(CTFrameParserConfig *)config{
    CGFloat fontSize=config.fontSize;
    CTFontRef fontRef=CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing=config.lineSpace;
    const CFIndex kNumberOfSetting=3;
    CTParagraphStyleSetting theSettings[kNumberOfSetting]={
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpacing}
    
    };
    
    CTParagraphStyleRef theParagraphRef=CTParagraphStyleCreate(theSettings, kNumberOfSetting);
    UIColor *textColor=config.textColor;
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[(id)kCTForegroundColorAttributeName]=(id)textColor.CGColor;
    dict[(id)kCTFontAttributeName]=(__bridge id)(fontRef);
    dict[(id)kCTParagraphStyleAttributeName]=(__bridge id)(theParagraphRef);
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+(CoreTextData *)pareContent:(NSString *)content config:(CTFrameParserConfig *)config{
    NSDictionary *attributes=[self attributesWithConfig:config];
    NSAttributedString *contentString=[[NSAttributedString alloc]initWithString:content attributes:attributes];
    
    //创建CTFrameSetterRef实例
    CTFramesetterRef framesetter=CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    //获取要绘制区域的高度
    CGSize restricSize=CGSizeMake(config.widht, CGFLOAT_MAX);
    CGSize coreTextSize=CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restricSize, nil);
    
    CGFloat textHeight=coreTextSize.height;
    
    //生成ctframeRef实例
    CTFrameRef frame=[self createFrameWithFramesetter:framesetter config:config height:textHeight];
    //将生成好的ctframeRef实例和计算好的绘制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    
    CoreTextData *data=[[CoreTextData alloc]init];
    data.ctframe=frame;
    data.height=textHeight;
    //释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+(CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                 config:(CTFrameParserConfig*)config
                                 height:(CGFloat)height{
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathAddRect(path, NULL,CGRectMake(0, 0, config.widht, height));
    CTFrameRef frame=CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    CFRelease(path);
    return frame;
}

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.widht, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctframe = frame;
    data.height = textHeight;
    data.content = content;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}


+(CoreTextData*)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config{
    NSAttributedString *content=[self loadTemplateFile:path config:config];
    
    return [self parseAttributedContent:content config:config];
}

+(NSAttributedString *)loadTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config{
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result=[[NSMutableAttributedString alloc]init];
    if(data){
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([array isKindOfClass:[NSArray class]]){
            for (NSDictionary *dict in array) {
                NSString *type=dict[@"type"];
                if([type isEqualToString:@"txt"]){
                    NSAttributedString *as=[self pareseAttributedContentFromNSdictionary:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
   
  }
     return result;
}



//方法3
+(NSAttributedString *)pareseAttributedContentFromNSdictionary:(NSDictionary *)dict
                                                        config:(CTFrameParserConfig *)config
{
    NSMutableDictionary *attributes=[self attributesWithConfig:config];
    //set color
    UIColor *color=[self colorFromTemplate:dict[@"color"]];
    if(color){
        attributes[(id)kCTForegroundColorAttributeName]=(id)color.CGColor;
    }
    
    //set font size
    CGFloat fontSize=[dict[@"size"] floatValue];
    if(fontSize>0){
        CTFontRef fontRef=CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName]=(__bridge id)(fontRef);
        
        CFRelease(fontRef);
    }
    
    NSString *content=dict[@"content"];
    return [[NSAttributedString alloc]initWithString:content attributes:attributes];
}

//方法4
+(UIColor *)colorFromTemplate:(NSString *)name{
    if([name isEqualToString:@"blue"]){
        return [UIColor blueColor];
    }else if([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else if([name isEqualToString:@"black"]){
        return [UIColor blackColor];
    }else{
        return nil;
    }
}



@end
