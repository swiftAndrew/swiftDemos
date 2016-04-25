//  Copyright (c) 2015 Razeware LLC. All rights reserved.

import UIKit


class CardNode : ASDisplayNode {
    
    
    let imageNode : ASImageNode
    let titleNode : ASTextNode
    
    init(card:Card){
        imageNode=ASImageNode()
        titleNode=ASTextNode()
        super.init()
        setupSubnodewithCard(card)
        buildSubnodeHierarchy()
        
    }
    
    func setupSubnodewithCard(card:Card){
        imageNode.image=card.image
        titleNode.attributedString=NSAttributedString.attributedStringForTitleText(card.name)
    }
    
    func buildSubnodeHierarchy(){
     addSubnode(imageNode)
        addSubnode(titleNode)
    }
    
  override  func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
//        return CGSize(width: constrainedSize.width*0.2, height: constrainedSize.height*0.2)
    
    imageNode.measure(constrainedSize)
    let cardSize = imageNode.calculatedSize
    titleNode.measure(cardSize)
    return cardSize
    }
    
    
   override func layout() {
        imageNode.frame=CGRect(origin: CGPointZero, size: imageNode.calculatedSize).integral
    
    
    titleNode.frame=FrameCalculator.titleFrameForSize(titleNode.calculatedSize, containerFrame: imageNode.frame)
    }
}
