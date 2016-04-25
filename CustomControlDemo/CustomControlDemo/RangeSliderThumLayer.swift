//
//  RangeSliderThumLayer.swift
//  CustomControlDemo
//
//  Created by Andrew on 14/12/18.
//  Copyright (c) 2014年 Andrew. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderThumLayer: CALayer {
    var highlighted:Bool=false{
        didSet{
            setNeedsDisplay();
        }
    }
    weak var rangeSlider:RangeSlider?;
    
    override func drawInContext(ctx: CGContext!) {
        if let slider=rangeSlider{
            let thumbFrame=bounds.rectByInsetting(dx: 2.0, dy: 2.0);
            let cornerRadius = thumbFrame.height * slider.curvaceousness / 2
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
            //Fill - with a
            let shadowColor=UIColor.grayColor()
            let size=CGSize(width: 0, height: 1);
            CGContextSetShadowWithColor(ctx,size, 1, shadowColor.CGColor);
            CGContextSetFillColorWithColor(ctx, slider.thumbTintColor.CGColor)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextFillPath(ctx)
            //outline
            CGContextSetStrokeColorWithColor(ctx,shadowColor.CGColor)
            CGContextSetLineWidth(ctx, 0.5)
            CGContextAddPath(ctx, thumbPath.CGPath)
            CGContextStrokePath(ctx)
            
            if highlighted{
                CGContextSetFillColorWithColor(ctx, UIColor(white: 0, alpha: 0.1).CGColor)
                CGContextAddPath(ctx, thumbPath.CGPath)
                CGContextFillPath(ctx)
                
            }
        }
    }
}








































