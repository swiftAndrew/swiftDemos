//
//  ViewController.swift
//  UpdateDemo
//
//  Created by Andrew on 15/7/7.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        // Do any additional setup after loading the view, typically from a nib.
        var label:UILabel = UILabel(frame:CGRectMake(100, 100,300,100));
        label.text = "输出结果在控制台"
        self.view.addSubview(label)
        //测试Swift调用Object的XML库功能
        testXML()
         initData();
    }

    func initData(){
        requestUrl("https://dn-waterpro.qbox.me/video1.0.plist");
        
    
        //取得本地程序的版本号
        
        var localDict:NSDictionary=NSBundle.mainBundle().infoDictionary!;
      //CFBundleShortVersionString
        var version:String=localDict.objectForKey("CFBundleShortVersionString") as String;
        
        println("本地版本号:\(version)")
        
    }
    
    
    func requestUrl(urlString:String){
        var url:NSURL=NSURL(string: urlString)!;
        let request:NSURLRequest=NSURLRequest(URL: url);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if((error?) != nil){
                
            }else{
                
                var err:NSError?
                
                var diaryList:String = NSBundle.mainBundle().pathForResource("person", ofType:"xml")!
                var data:NSMutableDictionary = NSMutableDictionary(contentsOfFile:diaryList)!
                var diaries:NSArray = data.objectForKey("items") as NSArray
                println(data)
                
               
               // var doc:GDataXMLDocument = GDataXMLDocument(data:data, options : 0, error : nil)
                
//                let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error:&err );
//                
//                let dict:NSDictionary=jsonObject as NSDictionary;
               // print("\(doc)");
                //获取xml文件路径
//                var path = NSBundle.mainBundle().pathForResource("person", ofType:"xml")
//                //获取xml文件内容
//                var xmlData = NSData(contentsOfFile:path!)
//             
//                
//                //通过XPath方式获取根目录几点下所有的 dict 节点，在路径特别复杂时特别方便
//                var doc:GDataXMLDocument = GDataXMLDocument(data:xmlData, options : 0, error : nil)
//                //通过XPath方式获取Users节点下的所有User节点，在路径复杂时特别方便
//                var users = doc.nodesForXPath("//array", error:nil) as [GDataXMLElement]
//                var Myusers = doc.rootElement().elementsForName("array") as [GDataXMLElement]
//                for user in users{
//                    //获取name节点元素
//                    let nameElement = user.elementsForName("key")[0] as GDataXMLElement
//                    //获取name节点元素
//                    let valueElement = user.elementsForName("string")[0] as GDataXMLElement
//                    println("key=\(nameElement),value=\(valueElement)")
//                }
                
            }
            
        }
    }
    
    
    
    func testXML() {
        //获取xml文件路径
        var path = NSBundle.mainBundle().pathForResource("users", ofType:"xml")
        //获取xml文件内容
        var xmlData = NSData(contentsOfFile:path!)
        //可以转换为字符串输出查看
        //println(NSString(data:xmlData, encoding:NSUTF8StringEncoding))
        
        //使用NSData对象初始化文档对象
        //这里的语法已经把OC的初始化函数直接转换过来了
        var doc:GDataXMLDocument = GDataXMLDocument(data:xmlData, options : 0, error : nil)
        
        //获取Users节点下的所有User节点，显式转换为element类型编译器就不会警告了
        //var users = doc.rootElement().elementsForName("User") as GDataXMLElement[]
        
        //通过XPath方式获取Users节点下的所有User节点，在路径复杂时特别方便
        var users = doc.nodesForXPath("//User", error:nil) as [GDataXMLElement]
        
        for user in users {
            //User节点的id属性
            let uid = user.attributeForName("id").stringValue()
            //获取name节点元素
            let nameElement = user.elementsForName("name")[0] as GDataXMLElement
            //获取元素的值
            let uname =  nameElement.stringValue()
            //获取tel子节点
            let telElement = user.elementsForName("tel")[0] as GDataXMLElement
            //获取tel节点下mobile和home节点
            let mobile = (telElement.elementsForName("mobile")[0] as GDataXMLElement).stringValue()
            let home = (telElement.elementsForName("home")[0] as GDataXMLElement).stringValue()
            //输出调试信息
            println("User: uid:\(uid),uname:\(uname),mobile:\(mobile),home:\(home)")
        }
    }
    


}

