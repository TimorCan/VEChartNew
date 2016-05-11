//
//  VEChart.h
//  VEChart
//
//  Created by juxi-ios on 16/4/11.
//  Copyright © 2016年 zhoucan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VEChartStyle) {
    VEChartStyleLine = 0,
    VEChartStyleBar  = 1,
    VEChartStyleCombie  = 2,
    VEChartStyleCurve  = 3
};


@interface VEChart : UIView

@property(nonatomic,assign)VEChartStyle chartStyle;

-(instancetype)initWithFrame:(CGRect)frame X_values:(NSArray *)x_values Y_values:(NSArray *)y_values;


@end
