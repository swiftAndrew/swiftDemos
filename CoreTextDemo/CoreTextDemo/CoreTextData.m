//
//  CoreTextData.m
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData
-(void)setCtframe:(CTFrameRef)ctframe{
    if(_ctframe!=ctframe){
        if(_ctframe!=nil){
            CFRelease(_ctframe);
        }
        CFRetain(ctframe);
        _ctframe=ctframe;
    }
}

-(void)dealloc{
    if(_ctframe!=nil){
        CFRelease(_ctframe);
        _ctframe=nil;
    }
}

-(void)setImageArray:(NSArray *)imageArray{
    _imageArray=imageArray;
    
}

-(void)fillImagePosition{
    if(self.imageArray.count==0){
        return;
    }
    NSArray *lines=(NSArray*)CTFrameGetLines(self.ctframe);
    int lineCount=[lines count];
    CGPoint lineOrigins[lineCount];
    
    CTFrameGetLineOrigins(self.ctframe, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex=0;
    CoreTextImageData *imageData=self.imageArray[0];
    
    for (int i=0; i<lineCount; ++i) {
        if(imageData==nil){
            break;
        }
        
        CTLineRef line=(__bridge CTLineRef)(lines[i]);
        NSArray *runObjArray=(NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run=(__bridge CTRunRef)(runObj);
            NSDictionary *runAttributes=CTRunGetAttributes(run);
        }
    }
    
}






@end
