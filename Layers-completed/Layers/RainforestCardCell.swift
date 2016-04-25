//
//  RainforestCardCell.swift
//  Layers
//
//  Created by René Cacheaux on 9/1/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class RainforestCardCell: UICollectionViewCell {

    var featureImageSizeOptional: CGSize?
    //占位的layer
    var placeholderLayer:CALayer!
    
    var contentLayer:CALayer?
    var containerNode:ASDisplayNode?
    
    var nodeConstructionOperation:NSOperation?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  
    contentView.layer.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
    contentView.layer.borderWidth = 1
    
    placeholderLayer=CALayer()
    placeholderLayer.contents = UIImage(named: "cardPlaceholder")!.CGImage
    placeholderLayer.contentsGravity = kCAGravityCenter
    placeholderLayer.contentsScale=UIScreen.mainScreen().scale
    placeholderLayer.backgroundColor=UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1).CGColor
    contentView.layer.addSublayer(placeholderLayer)
  }

  //MARK: Layout
  override func sizeThatFits(size: CGSize) -> CGSize {
    if let featureImageSize = featureImageSizeOptional {
      return FrameCalculator.sizeThatFits(size, withImageSize: featureImageSize)
    } else {
      return CGSizeZero
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    placeholderLayer?.frame = bounds
    CATransaction.commit()
    
    
  }
  
  //MARK: Cell Reuse
  override func prepareForReuse() {
    super.prepareForReuse()
    
    //异步取消
    if let operation = nodeConstructionOperation{
        operation.cancel()
    }
    //因为 AsyncDisplayKit 能够异步地绘制 Node，所以 Node 让你能预防从头绘制或取消任何在进行的绘制。无论是你需要预防或取消绘制，都可将 preventOrCancelDisplay 设置为 true
   // backgroundImageNode?.preventOrCancelDisplay=true
    //递归取消子node的取消绘制
    containerNode?.recursiveSetPreventOrCancelDisplay(true)
    contentLayer?.removeFromSuperlayer()
    
    
    
    
    // 释放掉
    contentLayer=nil
    //backgroundImageNode=nil
    //释放
    containerNode=nil
  }
  
  //MARK: Cell Content
 
    
    func configureCellDisplayWithCardInfo(cardInfo:RainforestCardInfo,
        nodeConstructionQueue:NSOperationQueue){
    
            if let oldNodeConstructOperation = nodeConstructionOperation{
                oldNodeConstructOperation.cancel()
            }
            
            let image=UIImage(named: cardInfo.imageName)!
            featureImageSizeOptional = image.size
            
            let newNodeConstructionOperation = nodeConstructOperationWithCardInfo(cardInfo, image: image)
            nodeConstructionOperation=newNodeConstructionOperation
            nodeConstructionQueue.addOperation(newNodeConstructionOperation)
    }
    
    func nodeConstructOperationWithCardInfo(cardInfo:RainforestCardInfo,image:UIImage)->NSOperation{
     let nodeConstructionOperation=NSBlockOperation()
        nodeConstructionOperation.addExecutionBlock { [weak self, unowned nodeConstructionOperation ]in
            // TODO: Add node hierarchy construction
            if nodeConstructionOperation.cancelled{
               return
            }
            
            
            //================================
            if let strongSelf = self {
                
               
                
                
                //MARK: Node create Section
                let backgroundImageNode=ASImageNode()
                backgroundImageNode.image=image
                backgroundImageNode.contentMode = .ScaleAspectFill
                backgroundImageNode.layerBacked=true
                
                //MARK: Container Node creation Section
                //let containerNode = ASDisplayNode()
                
                let containerNode = ASDisplayNode(layerClass: AnimatedContentsDisplayLayer.self)
                
                containerNode.layerBacked=true
                //这是一个关于节点如何工作的提示以及一个如何让它们工作得更好地机会
                containerNode.shouldRasterizeDescendants=true
                containerNode.borderColor=UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
                containerNode.borderWidth=1
                
                //MARK: Node Hierarchy Section
                containerNode.addSubnode(backgroundImageNode)
                
                
                
                
                
                
                //添加显示图片的node
                let featureImageNode = ASImageNode()
                featureImageNode.layerBacked=true
                featureImageNode.contentMode = .ScaleAspectFill
                featureImageNode.image=image
                
                
                //添加标题的node
                let titleTextNode = ASTextNode()
                titleTextNode.layerBacked=true
                titleTextNode.backgroundColor=UIColor.clearColor()
                titleTextNode.attributedString=NSAttributedString.attributedStringForTitleText(cardInfo.name)
                
                //添加详细描述
                let descriptionTextNode = ASTextNode()
                descriptionTextNode.layerBacked=true
                descriptionTextNode.backgroundColor=UIColor.clearColor()
                descriptionTextNode.attributedString=NSAttributedString.attributedStringForTitleText(cardInfo.description)
                
                //添加梯度Node
                let gradientNode = GradientNode()
                gradientNode.opaque=false
                gradientNode.layerBacked=true
                
                //加入到根Node中
                containerNode.addSubnode(featureImageNode)
                containerNode.addSubnode(titleTextNode)
                containerNode.addSubnode(descriptionTextNode)
                containerNode.addSubnode(gradientNode)
                
                //MARK: Node Layout section
                containerNode.frame=FrameCalculator.frameForContainer(featureImageSize: image.size)
                backgroundImageNode.frame=FrameCalculator.frameForBackgroundImage(containerBounds: containerNode.bounds)
                featureImageNode.frame=FrameCalculator.frameForFeatureImage(featureImageSize: image.size, containerFrameWidth: containerNode.frame.size.width)
                
                titleTextNode.frame=FrameCalculator.frameForTitleText(containerBounds: containerNode.bounds, featureImageFrame: featureImageNode.frame)
                
                descriptionTextNode.frame=FrameCalculator.frameForDescriptionText(containerBounds: containerNode.bounds, featureImageFrame: featureImageNode.frame)
                
                gradientNode.frame=FrameCalculator.frameForGradient(featureImageFrame: featureImageNode.frame)
                
                print("=====cell.sublayers:\(strongSelf.contentView.layer.sublayers)")
                
                
                //添加模糊效果
                backgroundImageNode.imageModificationBlock = { input in
                    
                    if input == nil{
                        return input
                    }
                    
                    //Add From here
                    let didCancelBlur:()->Bool = {
                        var isCanceled = true
                        if let strongBackgroundImageNode=backgroundImageNode{
                            let isCancelClosure = {
                                isCanceled = strongBackgroundImageNode.preventOrCancelDisplay
                            }
                            //如果是主线程，执行闭包中的内容
                            if NSThread.isMainThread(){
                                isCancelClosure()
                            }else{
                                dispatch_sync(dispatch_get_main_queue(), isCancelClosure)
                            }
                        }
                        return isCanceled
                    }
                    
                    if let blurredImage = input.applyBlurWithRadius(30,
                        tintColor:UIColor(white: 0.5, alpha: 0.3),
                        saturationDeltaFactor:1.8,
                        maskImage:nil,
                        didCancel:didCancelBlur){
                            return blurredImage
                    } else {
                        return image;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {[weak nodeConstructionOperation] in
                    if let strongNodeConstructionOperation = nodeConstructionOperation{
                        if strongNodeConstructionOperation.cancelled{
                            return
                        }
                        
                        if strongSelf.nodeConstructionOperation !== strongNodeConstructionOperation{
                            return
                        }
                        
                        if containerNode!.preventOrCancelDisplay{
                            return
                        }
                        
                        strongSelf.contentView.layer.addSublayer(containerNode.layer)
                        strongSelf.contentLayer=containerNode.layer
                        //住你需要保留你自己的 Node ，如果你不这么做它们就会被立即释放
                        strongSelf.containerNode=containerNode
                        containerNode.setNeedsDisplay()
                    }
                    
                }
                
            }
            
        }
        
        return nodeConstructionOperation
    }
  
}





