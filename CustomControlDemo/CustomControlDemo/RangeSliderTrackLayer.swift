//
//  RangeSliderTrackLayer.swift
//  CustomControlDemo
//
//  Created by Andrew on 14/12/18.
//  Copyright (c) 2014年 Andrew. All rights reserved.
//

import UIKit
import QuartzCore
class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider : RangeSlider?
    override func drawInContext(ctx: CGContext!) {
        if let slider = rangeSlider{
           //clip
            let cornerRadius = bounds.height * slider.curvaceousness/2
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: 15)
//            println( NSs);
            CGContextAddPath(ctx, path.CGPath)
            
            //Fill  the track
            CGContextSetFillColorWithColor(ctx, slider.trackTintColor.CGColor)
            CGContextAddPath(ctx, path.CGPath)
            CGContextFillPath(ctx)
            
            //Fill the highlighted range
            CGContextSetFillColorWithColor(ctx, slider.trackHighlightTintColor.CGColor)
            let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
            let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
            
            let rect=CGRect(x: lowerValuePosition, y: 0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            CGContextFillRect(ctx, rect)
            
            

            
        }
    }
}





































