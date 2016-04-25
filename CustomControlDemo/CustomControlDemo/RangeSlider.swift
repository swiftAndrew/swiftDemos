//
//  RangeSlider.swift
//  CustomControlDemo
//
//  Created by Andrew on 14/12/18.
//  Copyright (c) 2014年 Andrew. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    let trackLayer=RangeSliderTrackLayer();
    let lowerThumbLayer=RangeSliderThumLayer();
    let upperThumbLayer=RangeSliderThumLayer();
    
    var previousLocation=CGPoint();
    var minimumValue:Double = 0.0{
        didSet{
            updateLayerFrame();
        }
    }
    
    var maxmumValue: Double=1.0{
        didSet{
            updateLayerFrame();
            
        }
    }
    
    var lowerValue:Double = 0.2{
        didSet{
            updateLayerFrame();
        }
    }
    
    var upperValue:Double=0.8{
        didSet{
            updateLayerFrame();
        }
    }
    var trackTintColor:UIColor=UIColor(white: 0.9, alpha: 1.0){
        didSet{
            trackLayer.setNeedsDisplay();
        }
    }
    
    var trackHighlightTintColor:UIColor=UIColor(red: 0, green: 0.45, blue: 0.95, alpha: 1){
        didSet{
            trackLayer.setNeedsDisplay();
        }
    }
    var thumbTintColor:UIColor=UIColor.whiteColor(){
        didSet{
            lowerThumbLayer.setNeedsDisplay();
            upperThumbLayer.setNeedsDisplay();
        }
    }
    
    var curvaceousness:CGFloat=1.0{
        didSet{
            trackLayer.setNeedsDisplay();
            lowerThumbLayer.setNeedsDisplay();
            upperThumbLayer.setNeedsDisplay();
        }
    }
    
    var thumbWidth:CGFloat{
        return CGFloat(bounds.height);
    }
    
    
    
    func updateLayerFrame(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame=bounds.rectByInsetting(dx: 0, dy: bounds.height/3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerThumbLayer.frame=CGRect(x: lowerThumbCenter - thumbWidth/2, y: 0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        
        let uppderThumbCenter=CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame=CGRect(x: uppderThumbCenter - thumbWidth/2, y: 0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction .commit()
    }
    
    func positionForValue(value: Double)->Double{
        let widthDouble=Double(thumbWidth);
        return Double(bounds.width - thumbWidth)*(value - minimumValue)/(maxmumValue - minimumValue) + Double(thumbWidth/2);
    }
  
    
 
    
   override var frame:CGRect{
       didSet{
        updateLayerFrame();
       }
      
    }
    
    /*! MacBook Pro 2014-12-18 15:43 编辑
    
    :param: frame 初始化的方法
    
    :returns:
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        trackLayer.rangeSlider=self;
        trackLayer.contentsScale=UIScreen.mainScreen().scale;
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider=self
        lowerThumbLayer.contentsScale=UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider=self
        upperThumbLayer.contentsScale=UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        fatalError("init(coder:) has not been implemented")
    }
    
    //Touch handlers
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        previousLocation = touch.locationInView(self)
        if lowerThumbLayer.frame.contains(previousLocation){
           lowerThumbLayer.highlighted = true
        }else if upperThumbLayer.frame.contains(previousLocation){
           upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerVaule: Double, upperValue: Double)-> Double{
      return  min(max(value, lowerValue), upperValue)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let location = touch.locationInView(self)
        
        //1.Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltValue = (maxmumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        //2. Update the values
        if lowerThumbLayer.highlighted{
            lowerValue += deltValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted{
            upperValue += deltValue
            upperValue  = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maxmumValue)
        }
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        lowerThumbLayer.highlighted=false
        upperThumbLayer.highlighted=false
    }
    
    
}



























