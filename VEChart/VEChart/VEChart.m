//
//  VEChart.m
//  VEChart
//
//  Created by juxi-ios on 16/4/11.
//  Copyright © 2016年 zhoucan. All rights reserved.
//

#import "VEChart.h"
#import "UIBezierPath+curved.h"

@interface VEChart()


//@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@property(nonatomic,copy)NSArray * x_values;

@property(nonatomic,copy)NSArray * y_values;

@property(nonatomic,assign)CGFloat maxHeight;//最高

@property(nonatomic,assign)CGFloat VEChartSpace;//空格

@end

#define VEBarWidth  25     //bar 宽度

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

@implementation VEChart


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(instancetype)initWithFrame:(CGRect)frame X_values:(NSArray *)x_values Y_values:(NSArray *)y_values{

    
    self =  [super init];
    if (self) {
        self.frame = frame;
         self.backgroundColor = [UIColor clearColor];
        self.x_values = x_values; //接受x_value数组
        self.y_values = y_values; //接受y_value数组
        
        //最大值高度
        self.maxHeight = frame.size.height * 0.6 ;
        
        //空格
        self.VEChartSpace = (frame.size.width - VEBarWidth * self.x_values.count)/(self.x_values.count+1) * 1.0;
        
        
    }
    return self;


}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.y_values == nil ||self.y_values.count == 0) {
        return;
    }

    
    switch (_chartStyle) {
        case VEChartStyleLine:
        {
            [self configLineChart];
        }
            break;
        case VEChartStyleBar:
        {
            [self configBarChart];
        }
            break;
        case VEChartStyleCombie:
        {
            [self configBarChart];
        }
            break;
        case VEChartStyleCurve:
        {
            [self configLineChart];
        }
            break;
            
        default:
            NSLog(@"没有指定charStyle");
            break;
    }
    
    
    
    
    
    
    
    
    
    
}

#pragma mark -- config LineChart
-(void)configLineChart
{
    NSArray * maxYarray = [self.y_values copy];
    
    [maxYarray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return   obj1 >  obj2;
    }];
    
    /**
     *  最大的值
     */
    double maxfloat = [[maxYarray objectAtIndex:0] doubleValue] ;
    
    
    NSMutableArray * y_height = [NSMutableArray array];
    
    [self.y_values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double height =  [obj doubleValue];
        
        double Ratio = maxfloat / self.maxHeight*1.0;
        
        double lastHeight = height / Ratio;
        
        [y_height addObject:@(lastHeight)];
        
    }];
    
    __block  UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 3.f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    // __block  CGFloat valueHeight = 0; //上方显示的value值
    
    
    //绘制Bar
    [y_height enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double height = [obj doubleValue];
        
        CGPoint point = CGPointMake(_VEChartSpace + (VEBarWidth + _VEChartSpace)*idx, self.frame.size.height - 20 - height);
        UIColor * color =[UIColor colorWithRed:1/255.f green:144/255.f  blue:204/255.f  alpha:1.f];
        [color set];
        [self addCircleAtPoint:point color:color];
        if (idx==0) {
            
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
            
            
        }
        
        if (idx == self.y_values.count -1) {
            
            if (self.chartStyle == VEChartStyleCurve) {
                path = [path smoothedPathWithGranularity:20];
            }
            [path stroke];
            
        }
  
        
        CGRect rect1 = CGRectMake(point.x,point.y -30 , 60, 20 );
        
       
        
        
        
        //Bar value
        
        NSInteger yvalue = [[self.y_values objectAtIndex:idx]integerValue];
        
        [self configLabelWith:rect1 text:[NSString stringWithFormat:@"%ld",(long)yvalue] font:[UIFont systemFontOfSize:10.f] Color:[UIColor colorWithRed:1/255.f green:144/255.f  blue:204/255.f  alpha:1.f] Center:point];

    }];
    
}

#pragma mark -- config BarChart
-(void)configBarChart
{
    NSArray * maxYarray = [self.y_values copy];
    
    [maxYarray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return   obj1 >  obj2;
    }];
    
    
    /**
     *  最大的值
     */
    double maxfloat = [[maxYarray objectAtIndex:0] doubleValue] ;
    
    
    NSMutableArray * y_height = [NSMutableArray array];
    
    [self.y_values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double height =  [obj doubleValue];
        
        double Ratio = maxfloat / self.maxHeight*1.0;
        
        double lastHeight = height / Ratio;
        
        [y_height addObject:@(lastHeight)];
        
    }];
    
    
  __block  UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 3.f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
  __block  CGFloat valueHeight = 0; //上方显示的value值
    
    
    //绘制Bar
    [y_height enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double height = [obj doubleValue];
        
        //Bar
        UILabel * label = [UILabel new];
        label.frame = CGRectMake(_VEChartSpace + (VEBarWidth + _VEChartSpace)*idx, self.frame.size.height - 20 - height, VEBarWidth, height);
        label.backgroundColor = [UIColor colorWithRed:1/255.f green:144/255.f  blue:204/255.f  alpha:1.f];
        
        [self addSubview:label];
        
        
        
        if(self.chartStyle == VEChartStyleCombie){
          //如果是combine bar
           
            
            
            UIColor * color =[UIColor colorWithRed:1/255.f green:144/255.f  blue:204/255.f  alpha:1.f];
            [color set];
            
            
            CGPoint point = CGPointMake(label.center.x, label.frame.origin.y-10);
            [self addCircleAtPoint:point color:color];
            
            if (idx==0) {
                
                [path moveToPoint:point];
            }else{
                [path addLineToPoint:point];
                
                
            }
            
            if (idx == self.y_values.count -1) {
//                [path closePath];
                [path stroke];
//                _shapeLayer.path = path.CGPath;

            }
            
            valueHeight = 10;
        }
        
        
        
        
        
        CGRect rect1 = CGRectMake(label.frame.origin.x, label.frame.origin.y - 20 -valueHeight , 60, 20 );
        CGRect rect2 = CGRectMake(label.frame.origin.x, label.frame.origin.y + height , 60, 20);
        ;
        
        
        
        //Bar value
        
        NSInteger yvalue = [[self.y_values objectAtIndex:idx]integerValue];
        
        [self configLabelWith:rect1 text:[NSString stringWithFormat:@"%ld",(long)yvalue] font:[UIFont systemFontOfSize:10.f] Color:[UIColor colorWithRed:1/255.f green:144/255.f  blue:204/255.f  alpha:1.f] Center:label.center];
        
        [self configLabelWith:rect2 text:[self.x_values objectAtIndex:idx] font:[UIFont systemFontOfSize:10.f] Color:[UIColor blackColor] Center:label.center];
        
        //        [self drawTextInContext:nil text:[NSString stringWithFormat:@"%ld",(long)yvalue] inRect:rect1 font:[UIFont systemFontOfSize:10.f]];
        //
        //
        //
        //        //Bar x_value
        //       [self drawTextInContext:nil text:[self.x_values objectAtIndex:idx] inRect:rect2 font:[UIFont systemFontOfSize:10.f]];
    }];
    
    

}


#pragma mark -- addCircle
-(void)addCircleAtPoint:(CGPoint)point color:(UIColor *)color
{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 7, 7);
    btn.center = point;
    btn.layer.cornerRadius = btn.frame.size.width/2;
    btn.clipsToBounds = YES;
    btn.backgroundColor = color;
    [self addSubview:btn];
    
    
}
#pragma mark -- label value
-(void)configLabelWith:(CGRect)frame text:(NSString *)text font:(UIFont *)font Color:(UIColor *)color Center:(CGPoint)center
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.center = CGPointMake(center.x, frame.origin.y+frame.size.height/2);
    [self addSubview:label];
}



//

- (void)drawTextInContext:(CGContextRef )ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font
{
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        priceParagraphStyle.alignment = NSTextAlignmentLeft;
        
        [text drawInRect:rect
          withAttributes:@{ NSParagraphStyleAttributeName:priceParagraphStyle, NSFontAttributeName:font }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [text drawInRect:rect
                withFont:font
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
    }
}
@end
