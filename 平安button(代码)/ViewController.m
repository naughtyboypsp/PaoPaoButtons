//
//  ViewController.m
//  平安button(代码)
//
//  Created by perry on 15/11/26.
//  Copyright © 2015年 perry. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray* buttonArray;
@property (nonatomic, strong) NSMutableDictionary *buttonDict;
@property (nonatomic, strong) NSMutableArray* velocityArray;



@property (nonatomic,assign) CGPoint originalCenter;
@property (nonatomic,assign) CGPoint btnVelocity;
@property (nonatomic, strong) CADisplayLink* gameTimer;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *titleArray =[NSArray arrayWithObjects:@"大小便情况",@"流鼻涕",@"痰多",@"疑似感冒症状",@"消化情况",@"咳嗽",@"其他症状",@"舌苔与质情况",nil];
    self.buttonArray=[NSMutableArray array];
    self.velocityArray=[NSMutableArray array];

    for (int i=0; i<8; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor=[UIColor orangeColor];
        button.frame=CGRectMake((i%2)*160+20, (i/2)*120, 60, 60);
        button.layer.cornerRadius=30;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTintColor:[UIColor blackColor]];
        if (i==0||i==1) {
            button.backgroundColor=[UIColor redColor];
        }
        button.tag=i;
        
        CGPoint velocityPoint=CGPointMake([self arc4randomOneAndOne], [self arc4randomOneAndOne]);
        [self.velocityArray insertObject:[NSValue valueWithCGPoint:velocityPoint] atIndex:i];
        //NSLog(@"self.velocityArray=%@",self.velocityArray);
        
        [self.view addSubview:button];
        [self.buttonArray insertObject:button atIndex:i];
       // NSLog(@"self.buttonArray=%@",self.buttonArray);

        
        
    }
    
}

-(void)intersectWithScreen
{
    for (UIButton *button in self.buttonArray)
    {
        int i=button.tag;
        CGPoint pointTmp=[self.velocityArray[i] CGPointValue];
        if (CGRectGetMinY(button.frame) <=0)
        {
            float y=ABS(pointTmp.y);
            float x=pointTmp.x;
            pointTmp=CGPointMake(x, y);
            self.velocityArray[i]=[NSValue valueWithCGPoint:pointTmp];
        }
        if (CGRectGetMaxY(button.frame) >=480)
        {
            float y=-ABS(pointTmp.y);
            float x=pointTmp.x;
            pointTmp=CGPointMake(x, y);
            self.velocityArray[i]=[NSValue valueWithCGPoint:pointTmp];
        }
        if (CGRectGetMinX(button.frame) <=0)
        {
            float x=ABS(pointTmp.x);
            float y=pointTmp.y;
            pointTmp=CGPointMake(x, y);
            self.velocityArray[i]=[NSValue valueWithCGPoint:pointTmp];
        }
        if (CGRectGetMaxX(button.frame) >=320)
        {
            float x=-ABS(pointTmp.x);
            float y=pointTmp.y;
            pointTmp=CGPointMake(x, y);
            self.velocityArray[i]=[NSValue valueWithCGPoint:pointTmp];
        }
    }


}

-(void)intersectBetweenBtn
{
    for (int j=0; j<8; j++)
    {
        NSLog(@"大循环 j=%d",j);
        NSMutableArray *arrayTmp=[self.buttonArray mutableCopy];
//        NSLog(@"没删除 arrayTmp=%@",arrayTmp);
        UIButton *button=self.buttonArray[j];
        int n=button.tag;
        [arrayTmp removeObjectAtIndex:j];
//        NSLog(@"有删除 arrayTmp=%@",arrayTmp);

        for (int i=0; i<arrayTmp.count; i++)
        {
            NSLog(@"111 小循环 i=%d",i);
            UIButton *buttonTmp=arrayTmp[i];
            int m=buttonTmp.tag;
            NSLog(@"button.frame %f,%f",button.frame.origin.x,button.frame.origin.y);
            NSLog(@"btnTmp.frame %f,%f",buttonTmp.frame.origin.x,buttonTmp.frame.origin.y);

            if (CGRectIntersectsRect(button.frame, buttonTmp.frame))
            {
                NSLog(@"有碰撞");
                CGPoint pointTmp=[self.velocityArray[n] CGPointValue];
                float x=-(pointTmp.x);
                float y=-(pointTmp.y);
                pointTmp=CGPointMake(x, y);
                self.velocityArray[n]=[NSValue valueWithCGPoint:pointTmp];
                
                CGPoint pointTmpAgain=[self.velocityArray[m] CGPointValue];
                float xA=-(pointTmpAgain.x);
                float yA=-(pointTmpAgain.y);
                pointTmpAgain=CGPointMake(xA, yA);
                self.velocityArray[n]=[NSValue valueWithCGPoint:pointTmpAgain];
                
            }
        }

        
    }
    

}


-(float)arc4randomOneAndOne
{
    float n=arc4random()%100;
    if (n<50)
    {
        n=-1;
    }
    else
    {
        n=1;
    }
    return n;
}


- (void)step
{
    //NSLog(@"屏幕刷新了");
    [self intersectWithScreen];
    //[self intersectBetweenBtn];
    //[self intersectBetweenBtn2];
    [self intersectBetweenBtnFull];
    [self intersectBetweenBtnFullAgain];
    for (UIButton *button in self.buttonArray)
    {
        int i=button.tag;
        CGPoint pointTmp=[self.velocityArray[i] CGPointValue];
        float x=button.center.x+pointTmp.x;
        float y=button.center.y+pointTmp.y;
        [button setCenter:CGPointMake(x, y)];
    }
}

-(void)intersectBetweenBtn2
{
    UIButton *button0=self.buttonArray[0];
    UIButton *button1=self.buttonArray[1];
    if (CGRectIntersectsRect(button0.frame, button1.frame))
    {
        NSLog(@"有碰撞");
        CGPoint pointTmp=[self.velocityArray[0] CGPointValue];
        float x=-(pointTmp.x);
        float y=-(pointTmp.y);
        pointTmp=CGPointMake(x, y);
        self.velocityArray[0]=[NSValue valueWithCGPoint:pointTmp];
        
        CGPoint pointTmpAgain=[self.velocityArray[1] CGPointValue];
        float xA=-(pointTmpAgain.x);
        float yA=-(pointTmpAgain.y);
        pointTmpAgain=CGPointMake(xA, yA);
        self.velocityArray[1]=[NSValue valueWithCGPoint:pointTmpAgain];
    }
}


-(void)intersectBetweenBtnFull
{
    for(int i=0;i<8;i++)
   {
       UIButton *button1=self.buttonArray[i];
       for (int j=i+1; j<8; j++)
       {
           UIButton *button2=self.buttonArray[j];
           if (CGRectIntersectsRect(button1.frame, button2.frame))
           {
               CGPoint pointTmp=[self.velocityArray[i] CGPointValue];
               float x=-(pointTmp.x);
               float y=-(pointTmp.y);
               pointTmp=CGPointMake(x, y);
               self.velocityArray[i]=[NSValue valueWithCGPoint:pointTmp];
               
               CGPoint pointTmpAgain=[self.velocityArray[j] CGPointValue];
               float xA=-(pointTmpAgain.x);
               float yA=-(pointTmpAgain.y);
               pointTmpAgain=CGPointMake(xA, yA);
               self.velocityArray[j]=[NSValue valueWithCGPoint:pointTmpAgain];
           }
           
       }
       
   
   }
}

-(void)intersectBetweenBtnFullAgain
{
    for(int i=0;i<8;i++)
    {
        UIButton *button1=self.buttonArray[i];
        for (int j=0; j<8; j++)
        {
            if (i!=j)
            {
//                NSLog(@"i=%d  j=%d",i,j);
                UIButton *button2=self.buttonArray[j];
                if (CGRectIntersectsRect(button1.frame, button2.frame))
                {
                    NSLog(@"有碰撞");
                    CGPoint pointTmp=[self.velocityArray[i] CGPointValue];
                    float x=-(pointTmp.x);
                    float y=-(pointTmp.y);
                    pointTmp=CGPointMake(x, y);
                    self.velocityArray[i]=[NSValue valueWithCGPoint:pointTmp];
                    
                    CGPoint pointTmpAgain=[self.velocityArray[j] CGPointValue];
                    float xA=-(pointTmpAgain.x);
                    float yA=-(pointTmpAgain.y);
                    pointTmpAgain=CGPointMake(xA, yA);
                    self.velocityArray[j]=[NSValue valueWithCGPoint:pointTmpAgain];
                }
            }
        }
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"有点击");
    self.gameTimer=[CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    self.gameTimer.frameInterval=3;
    [self.gameTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

}
@end
