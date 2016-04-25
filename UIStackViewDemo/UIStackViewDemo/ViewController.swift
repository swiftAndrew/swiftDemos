//
//  ViewController.swift
//  UIStackViewDemo
//
//  Created by Andrew on 16/4/3.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var verticalStackView: UIStackView!
    
    @IBOutlet weak var horiStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var addStarBtn: UIButton!
   
    @IBOutlet weak var removeStarBtn: UIButton!
  
  
    @IBAction func addStarAction(sender: AnyObject) {
        
        let starImgView:UIImageView=UIImageView(image:UIImage(named: "star"));
        
        starImgView.contentMode = .ScaleAspectFit;
        self.horiStackView.addArrangedSubview(starImgView);
        
        UIView.animateWithDuration(0.25) { () -> Void in
          self.horiStackView.layoutIfNeeded()
            
        };
        
    }

    @IBAction func removeStarAction(sender: AnyObject) {
        
        let stat:UIView? = self.horiStackView.arrangedSubviews.last;
        if let aStar=stat{
         self.horiStackView.removeArrangedSubview(aStar)
            
            aStar.removeFromSuperview();
            UIView.animateWithDuration(0.25, animations: {
                self.horiStackView.layoutIfNeeded()
            })
        }
    }
}

