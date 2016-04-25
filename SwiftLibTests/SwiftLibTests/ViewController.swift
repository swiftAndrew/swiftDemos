//
//  ViewController.swift
//  SwiftLibTests
//
//  Created by Andrew on 16/3/23.
//  Copyright © 2016年 Andrew. All rights reserved.
//


import UIKit
import Kingfisher
import TLKeyboardUtil_Swift


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let iv:UIImageView=UIImageView(frame: CGRectMake(100, 100, 100, 100));
        self.view.addSubview(iv);
        
        
        let img:UIImage=UIImage(named:"1")!;
        let url:NSURL=NSURL(string: "http://7xkxhx.com1.z0.glb.clouddn.com/closureReferenceCycle01_2x.png")!;
        
        //iv.kf_setImageWithResource(Resource(downloadURL: url), placeholderImage: img);
        
        
        iv.kf_setImageWithURL(url, placeholderImage: img);

    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

