//
//  ViewController.swift
//  TipProject
//
//  Created by Andrew on 16/3/13.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,AVAudioPlayerDelegate {
    
    var startBtn:UIButton?
    var endBtn:UIButton?
    var setBtn:UIButton?
    
    var pickView:UIPickerView!;
    var bottomView:UIView!
    
    var arrayData:NSArray!
    var selectTime:Int?
    var tempSelect:Int?
    
    var tipLb:UILabel?
    var playTiplb:UILabel?
    //时间提示
    var startTimeLb:UILabel?
    
    //初始化一个定时器
    var timer:NSTimer?
    
    
    var audioPlayer:AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initView();
        
        
        arrayData=["1","5","10","15"];
        selectTime=10;
        tempSelect=arrayData[0].integerValue;
        initBottomView();
        initPlayer();
    }
    
    func initView(){
        
        let originX:CGFloat=20;
        let originY:CGFloat=20;
        let width:CGFloat=100;
        let height:CGFloat=40;
        
        let gap:CGFloat=15;
        var rect=CGRectMake(originX, originY, 200, height);
        
    
        
        //设置循环提示时间
        setBtn=createBtn(frame: rect, titleString: "设置循环提示时间")
        setBtn?.addTarget(self, action: Selector("setTime:"), forControlEvents: .TouchUpInside);
        self.view.addSubview(setBtn!);
        
        
        //开始时间
        rect=CGRectMake(originX, CGRectGetMaxY((setBtn?.frame)!)+gap,width, height);
        startBtn=createBtn(frame: rect, titleString: "开始计时");
        startBtn?.addTarget(self, action:Selector("startAction:"), forControlEvents: .TouchUpInside);
        
        self.view.addSubview(startBtn!);
    
        //停止
        rect=CGRectMake(originX, CGRectGetMaxY((startBtn?.frame)!)+gap,width, height);

        endBtn=createBtn(frame: rect, titleString: "停止");
        endBtn?.addTarget(self, action: Selector("endAction:"), forControlEvents: .TouchUpInside);
        self.view.addSubview(endBtn!);
        
        
        rect=CGRectMake(originX, CGRectGetMaxY((endBtn?.frame)!)+gap,300, height);
        tipLb=UILabel(frame: rect);
        tipLb?.textColor=UIColor.blueColor();
        tipLb?.text="默认循环时间是10分钟";
        self.view.addSubview(tipLb!);
        
        rect=CGRectMake(originX, CGRectGetMaxY((tipLb?.frame)!)+gap,300, height);
        playTiplb=UILabel(frame: rect);
        playTiplb?.textColor=UIColor.redColor();
        playTiplb?.text="";
        self.view.addSubview(playTiplb!);
        
        rect=CGRectMake(originX, CGRectGetMaxY((playTiplb?.frame)!)+gap,300, height);
        startTimeLb=UILabel(frame: rect);
        startTimeLb?.textColor=UIColor.redColor();
        self.view.addSubview(startTimeLb!);
        
        
        
    }
    
    func initTimer(){
        //timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
            //selector:@selector(updateProg) userInfo:nil repeats:YES];
        if(timer==nil){
            //60*10
          let  time:Double=Double.init(selectTime!);
          let intevalTime:NSTimeInterval=60.0*time;
            print("=====intevalTime=\(intevalTime)")
            
            
           timer=NSTimer.scheduledTimerWithTimeInterval(intevalTime, target: self, selector: Selector("playStart:"), userInfo: nil, repeats: true);
        
        }
        
        timer?.fire();
    }
    
    //初始化播放器
    func initPlayer(){
        // 获取要播放的音频文件的URL
        
        let fileUrl:NSURL=NSBundle.mainBundle().URLForResource("music", withExtension: "m4r")!;
        // 创建AVAudioPlayer对象
        audioPlayer=try? AVAudioPlayer.init(contentsOfURL: fileUrl);
        audioPlayer?.delegate=self;
        
        
        //这部分代码是支持手机进入后台后播放音频的，很关键
        let session:AVAudioSession=AVAudioSession.sharedInstance();
        try? session.setActive(true);
        //支持后台播放
        try? session.setCategory(AVAudioSessionCategoryPlayback);
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()

    }
    
    func initBottomView(){
        let screenWidth=UIScreen.mainScreen().bounds.width;
        let screenHeight=UIScreen.mainScreen().bounds.height;
        var rect:CGRect=CGRectMake(0, screenHeight, screenWidth, 300)
        bottomView=UIView(frame: rect);
        self.view.addSubview(bottomView);
        
        rect=CGRectMake(0, 0, screenWidth, 50);
        let tipView:UIView=UIView(frame: rect);
        tipView.backgroundColor=UIColor.brownColor();
        bottomView.addSubview(tipView);
        
        //取消按钮
        rect=CGRectMake(0, 0, 100, 50);
        let cancelBtn:UIButton=UIButton(frame: rect);
        cancelBtn.addTarget(self, action: Selector("cancelAction:"), forControlEvents: .TouchUpInside);
        cancelBtn.setTitle("取消", forState:.Normal);
        
        cancelBtn.setTitleColor(UIColor.redColor(), forState: .Normal);
        tipView.addSubview(cancelBtn);
        
        //确定按钮
        rect=CGRectMake(screenWidth-100, 0, 100, 50);
        let confirmBtn:UIButton=UIButton(frame: rect);
        confirmBtn.addTarget(self, action: Selector("confirmAction:"), forControlEvents: .TouchUpInside);
        confirmBtn.setTitle("确定", forState: .Normal);
        confirmBtn.setTitleColor(UIColor.redColor(), forState: .Normal);
        tipView.addSubview(confirmBtn);
        
        
        
        rect=CGRectMake(0, 50, screenWidth, 250)
        pickView=UIPickerView(frame: rect);
        pickView.delegate=self;
        pickView.dataSource=self;
        bottomView.addSubview(pickView);
        
      
        
    }
    

    //取消
    func cancelAction(sender:AnyObject){
        dismissPIckView();
    }
    
    //确定
    func confirmAction(sender:AnyObject){
        
         print("您选择的循环时间是\(tempSelect!)分钟")
        
        if(tempSelect>0){
            selectTime=tempSelect;
        }
        tipLb?.text="您选择循环提示时间是\(selectTime!)分钟";
        dismissPIckView();
    }
   
    
    func  dismissPIckView(){
        let screenWidth=UIScreen.mainScreen().bounds.width;
        let screenHeight=UIScreen.mainScreen().bounds.height;
        UIView.animateWithDuration(0.2) { () -> Void in
            let rect:CGRect=CGRectMake(0, screenHeight, screenWidth, 300);
            self.bottomView.frame=rect;
        }
    }
    
    func setTime(sender:AnyObject){
        print("设置提示时间");
        
        
        UIView.animateWithDuration(0.2) { () -> Void in
            var rect:CGRect=self.bottomView.frame;
            rect.origin.y -= 250;
            self.bottomView.frame=rect;
        }
    }
    
    //开始计时
    func startAction(sender:AnyObject){
        print("开始计时了");
        
       //audioPlayer?.play();
        playTiplb?.text="已经进入循环提示中...";
        
        initTimer();
       
    }
    
    func getCurrentTime()->String{
        let date:NSDate=NSDate();
        let dateFormatter:NSDateFormatter=NSDateFormatter();
        dateFormatter.dateFormat="yyyy-MM-dd hh:mm";
        let dateStr:String=dateFormatter.stringFromDate(date);
        return dateStr;
    }
    
    func playStart(sender:AnyObject){
        print("===开始进入播放环节==");
        audioPlayer?.play();
        
        let timeTip="上次播放时间:"+getCurrentTime();
        startTimeLb?.text=timeTip;
    }
    
    func endAction(sender:AnyObject){
        print("停止提示了");
        
        playTiplb?.text="终止循环了";
       
            timer?.invalidate();
            timer=nil;
        
        audioPlayer?.stop();
    }
    
    func createBtn(frame rect:CGRect,titleString title:String)->UIButton{
        let btn=UIButton(frame: rect);
        btn.setTitle(title, forState:UIControlState.Normal);
        btn.backgroundColor=UIColor.redColor();
        return btn;
    }

  
    
    
    //UIPickView Delegate...
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title=arrayData[row] as? String;
        title=title!+"分钟";
        return title;
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("\(arrayData[row])")
        tempSelect=arrayData[row].integerValue;
    
    }
    
    
    
    // 当AVAudioPlayer播放完成收将会自动激发该方法
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (player == audioPlayer && flag)
        {
            print("播放完成！！");
            playTiplb?.text="播放完成！"
            

            
        }
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        playTiplb?.text="被中断！！"
    }
    
    


}

