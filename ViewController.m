//
//  ViewController.m
//  抽屉
//
//  Created by Jusive on 15/11/25.
//  Copyright © 2015年 Jusive. All rights reserved.
//

#import "ViewController.h"
#define maxY 60
@interface ViewController ()
@property (nonatomic,weak) UIView *mainV;
@property (nonatomic,weak) UIView *leftV;
@property (nonatomic,weak) UIView *RightV;
@property (nonatomic,assign) BOOL isDranging;
@end

@implementation ViewController

-(void)addAllChildView{
    UIView *leftV = [[UIView alloc]initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftV];
    _leftV = leftV;
    UIView *RightV = [[UIView alloc]initWithFrame:self.view.bounds];
    RightV.backgroundColor = [UIColor greenColor];
    [self.view addSubview:RightV];
    _RightV = RightV;
    UIView *mainV = [[UIView alloc]initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainV];
    _mainV = mainV;
}
//时刻监听主视图的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.mainV.frame.origin.x < 0) {
        self.RightV.hidden = NO;
        self.leftV.hidden = YES;
    }else if(self.mainV.frame.origin.x > 0 ){
        self.RightV.hidden = YES;
        self.leftV.hidden = NO;
    }
}
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    // 获取手指每偏移一点,Y轴需要偏移多少
    CGFloat offsetY = offsetX * maxY / screenW;
    
    // 获取缩放比例
    CGFloat scale = (screenH - 2 * offsetY)/screenH;
    
    if (self.mainV.frame.origin.x < 0) {
        scale = (screenH + 2 * offsetY)/screenH;
    }
    
    // 计算当前视图的frame
    CGRect frame = self.mainV.frame;
    frame.origin.x += offsetX;
    frame.size.height = frame.size.height * scale;
    frame.size.width = frame.size.width *scale;
    frame.origin.y = (screenH - frame.size.height) * 0.5;
    
    return frame;
    
}
//touchmove
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event{
  //获取手指
    UITouch *touch = [touches anyObject];
    CGPoint curP = [touch locationInView:self.view];
    CGPoint preP = [touch precisePreviousLocationInView:self.view];
    CGFloat offsetX = curP.x - preP.x;
    
    self.mainV.frame = [self frameWithOffsetX:offsetX];
    self.isDranging = YES;
    }
#define targetRX 300;
#define targetLX -250;
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
if(self.isDranging == NO && self.mainV.frame.origin.x != 0){
     [UIView animateWithDuration:0.25 animations:^{
         self.mainV.frame = self.view.bounds;
     }];
    return;
    }
    //定位功能
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGRect frame = self.mainV.frame;
    CGFloat target = 0;
    if(frame.origin.x > screenW*0.5){
        target = targetRX;
    }else if(CGRectGetMaxX(self.mainV.frame)<screenW *0.5){
        target = targetLX;
    }
    if(target == 0){
    [UIView animateWithDuration:0.25 animations:^{
        self.mainV.frame = self.view.bounds;
    }];
    }else{
     [UIView animateWithDuration:0.25 animations:^{
         CGFloat offsetX = target - frame.origin.x;
          self.mainV.frame = [self frameWithOffsetX:offsetX];
     }];
    }
    self.isDranging  = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllChildView];
    [self.mainV addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
