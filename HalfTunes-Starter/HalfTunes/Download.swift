//
//  Download.swift
//  HalfTunes
//
//  Created by Andrew on 16/4/1.
//  Copyright © 2016年 Ken Toh. All rights reserved.
//

import UIKit

class Download: NSObject {
    var url: String
    var isDonwloading = false
    var progress:Float  = 0.0
    
    var downloadTask:NSURLSessionDownloadTask?
    var resumeData:NSData?
    
    init(url:String) {
        self.url=url;
    }
}
