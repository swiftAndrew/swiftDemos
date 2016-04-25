//
//  MyUrlProtocal.swift
//  NSURLProtocolExample
//
//  Created by Andrew on 14/12/19.
//  Copyright (c) 2014年 Zedenem. All rights reserved.
//

import UIKit
var requestCount = 0
var connection:NSURLConnection!


class MyUrlProtocal: NSURLProtocol {
    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        println("Request #\(requestCount++): URL = \(request.URL.absoluteString)")
        return true
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(aRequest: NSURLRequest,
        toRequest bRequest: NSURLRequest) -> Bool {
            return super.requestIsCacheEquivalent(aRequest, toRequest:bRequest)
    }
    
    override func startLoading() {
        connection = NSURLConnection(request: self.request, delegate: self)
    }
    
    override func stopLoading() {
        if connection != nil {
            connection.cancel()
        }
        connection = nil
    }
}


























