//
//  ViewController.m
//  CoreTextDemo
//
//  Created by Andrew on 15/6/17.
//  Copyright (c) 2015年 Andrew. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"

@interface ViewController ()
@property (nonatomic,strong)CTDisplayView *ctView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ctView=[[CTDisplayView alloc]initWithFrame:CGRectMake(10, 10, 300, 500)];
    [self.view addSubview:_ctView];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CTDDisplayView *display=[[CTDDisplayView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    display.center=self.view.center;
//    display.backgroundColor=[UIColor redColor];
//    [self.view addSubview:display];
    
    //[self settting1];
    [self settting2];
 
    
}

-(void)settting{
    CTFrameParserConfig *config=[[CTFrameParserConfig alloc]init];
    config.textColor=[UIColor redColor];
    config.widht=self.ctView.frame.size.width;
    
    CoreTextData *data=[CTFrameParser pareContent:@"按照以上原则，我们将'CTDisplayView'中的部分内容拆开" config:config];
    self.ctView.data=data;
    
    self.ctView.backgroundColor=[UIColor yellowColor];
}


-(void)settting1{
    CTFrameParserConfig *config=[[CTFrameParserConfig alloc]init];
    config.widht=self.ctView.frame.size.width;
    config.textColor=[UIColor orangeColor];
    
    NSString *content=@"新华网北京6月17日电  据新华社客户端报道，17日上午，习近平总书记从遵义乘车前往贵阳，中途来到久长停车服务区。总书记进入一家小超市。看到总书记，两位年轻服务员十分激动。总书记在食品区拿起一包“沙琪玛”，问服务员保质期，服务员看了生产日期后说是今年2月生产的，保质期有10个月。超市外有两处食品摊，习近平走过去，指着米黄粑、鸭脖子，饶有兴趣地了解有关情况";
    NSDictionary *attr=[CTFrameParser attributesWithConfig:config];
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc]initWithString:content attributes:attr];
    [attributedString addAttribute:NSFontAttributeName value:[UIColor redColor] range:NSMakeRange(0, 7)];
    CoreTextData *data=[CTFrameParser parseAttributedContent:attributedString config:config];
    
    self.ctView.data=data;
    self.ctView.backgroundColor=[UIColor yellowColor];
    
}

-(void)settting2{
    CTFrameParserConfig *config=[[CTFrameParserConfig alloc]init];
    config.widht=self.ctView.frame.size.width;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    
    CoreTextData *data=[CTFrameParser parseTemplateFile:path config:config];
    self.ctView.data=data;
    self.ctView.backgroundColor=[UIColor whiteColor];
}






@end
