//  Copyright (c) 2015 Razeware LLC. All rights reserved.

import Foundation

class FrameCalculator {
  
  class func titleFrameForSize(titleSize: CGSize, containerFrame: CGRect) -> CGRect {
    var calculatedTitleFrame = CGRect(origin: CGPointZero, size: titleSize)
    calculatedTitleFrame.origin.x = containerFrame.origin.x + 12.0
    calculatedTitleFrame.origin.y = containerFrame.maxY - 40.0
    return calculatedTitleFrame.integral
  }
  
  class func moreButtonFrameForSize(buttonSize: CGSize, containerFrame: CGRect) -> CGRect {
    var moreButtonOrigin = CGPoint(x: containerFrame.maxX, y: containerFrame.minY)
    moreButtonOrigin.x -= (buttonSize.width + 10.0)
    moreButtonOrigin.y += 10.0
    return CGRect(origin: moreButtonOrigin, size: buttonSize).integral
  }
  
  class func descriptionFrameForSize(descriptionSize: CGSize) -> CGRect {
    return CGRect(origin: CGPoint(x: 20, y: 54), size: descriptionSize).integral
  }
}
