//  Copyright (c) 2015 Razeware LLC. All rights reserved.

import UIKit

class ViewController: UIViewController {
  let card = Card(name: "Taj Mahal", image: UIImage(named:"TajMahal")!)
    var cardViewSetupStared = false
    

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //create ,configure ,and lay out container node
//            //let cardNode = createCardNode(containerRect: UIScreen.mainScreen().bounds)
////            cardNode.backgroundColor=UIColor(white: 1.0, alpha: 0.27)
////        let origin =  CGPointZero
////        let size  = CGSizeMake(100, 100)
////        cardNode.frame = CGRect(origin: origin, size: size)
//        //view.addSubview(cardNode.view)
//        
//        addCardViewAsynchronously(UIScreen.mainScreen().bounds)
//    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !cardViewSetupStared{
         addCardViewAsynchronously(UIScreen.mainScreen().bounds)
            cardViewSetupStared = true
        }
    }
    
    
    func addCardViewAsynchronously(containerRect:CGRect){
     dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
        let cardNode = self.createCardNode(containerRect: containerRect)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.view.addSubview(cardNode.view)
        })
        }
    }
    
    
    func createCardNode(containerRect containerRect: CGRect) ->CardNode{
       let cardNode = CardNode(card: card)
        cardNode.backgroundColor=UIColor(white: 1.0, alpha: 0.27)
        cardNode.measure(containerRect.size)
        
        let size = cardNode.calculatedSize
        let origin = containerRect.originForCenteredRectWithSize(size)
        cardNode.frame=CGRect(origin: origin, size: size)
        return cardNode
    }
    
}
