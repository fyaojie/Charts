//
//  DemoListViewController.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import "DemoListViewController.h"
#import "LineChart1ViewController.h"
#import "LineChart2ViewController.h"
#import "BarChartViewController.h"
#import "HorizontalBarChartViewController.h"
#import "CombinedChartViewController.h"
#import "PieChartViewController.h"
#import "PiePolylineChartViewController.h"
#import "ScatterChartViewController.h"
#import "StackedBarChartViewController.h"
#import "NegativeStackedBarChartViewController.h"
#import "AnotherBarChartViewController.h"
#import "MultipleLinesChartViewController.h"
#import "MultipleBarChartViewController.h"
#import "CandleStickChartViewController.h"
#import "CubicLineChartViewController.h"
#import "RadarChartViewController.h"
#import "ColoredLineChartViewController.h"
#import "SinusBarChartViewController.h"
#import "PositiveNegativeBarChartViewController.h"
#import "BubbleChartViewController.h"
#import "LineChartTimeViewController.h"
#import "LineChartFilledViewController.h"
#import "HalfPieChartViewController.h"

@interface DemoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *itemDefs;
@end

@implementation DemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Charts Demonstration";

    self.itemDefs = @[
                      @{
                          @"title": @"Line Chart 折线图",
                          @"subtitle": @"A simple demonstration of the linechart. 线条图的简单演示。",
                          @"class": LineChart1ViewController.class
                          },
                      @{
                          @"title": @"Line Chart (Dual YAxis) 折线图（双Y轴）",
                          @"subtitle": @"Demonstration of the linechart with dual y-axis. 双y轴线形图演示",
                          @"class": LineChart2ViewController.class
                          },
                      @{
                          @"title": @"Bar Chart 条形图",
                          @"subtitle": @"A simple demonstration of the bar chart. 条形图的简单演示。",
                          @"class": BarChartViewController.class
                          },
                      @{
                          @"title": @"Horizontal Bar Chart 水平条形图",
                          @"subtitle": @"A simple demonstration of the horizontal bar chart. 水平条形图的简单演示。",
                          @"class": HorizontalBarChartViewController.class
                          },
                      @{
                          @"title": @"Combined Chart 组合图表",
                          @"subtitle": @"Demonstrates how to create a combined chart (bar and line in this case). 演示如何创建组合图表（在本例中为条形图和折线图）。",
                          @"class": CombinedChartViewController.class
                          },
                      @{
                          @"title": @"Pie Chart 饼图",
                          @"subtitle": @"A simple demonstration of the pie chart. 饼图的简单演示。",
                          @"class": PieChartViewController.class
                          },
                      @{
                          @"title": @"Pie Chart with value lines 带值线的饼图",
                          @"subtitle": @"A simple demonstration of the pie chart with polyline notes. 带有折线注释的饼图的简单演示。",
                          @"class": PiePolylineChartViewController.class
                          },
                      @{
                          @"title": @"Scatter Chart 散布图",
                          @"subtitle": @"A simple demonstration of the scatter chart. 散点图的简单演示。",
                          @"class": ScatterChartViewController.class
                          },
                      @{
                          @"title": @"Bubble Chart 气泡图",
                          @"subtitle": @"A simple demonstration of the bubble chart. 气泡图的简单演示。",
                          @"class": BubbleChartViewController.class
                          },
                      @{
                          @"title": @"Stacked Bar Chart 堆叠横条图",
                          @"subtitle": @"A simple demonstration of a bar chart with stacked bars. 带有堆叠条形图的条形图的简单演示。",
                          @"class": StackedBarChartViewController.class
                          },
                      @{
                          @"title": @"Stacked Bar Chart Negative 堆积条形图负片",
                          @"subtitle": @"A simple demonstration of stacked bars with negative and positive values. 具有负值和正值的堆叠钢筋的简单演示。",
                          @"class": NegativeStackedBarChartViewController.class
                          },
                      @{
                          @"title": @"Another Bar Chart 另一个条形图",
                          @"subtitle": @"Implementation of a BarChart that only shows values at the bottom. 只在底部显示值的BarChart的实现。",
                          @"class": AnotherBarChartViewController.class
                          },
                      @{
                          @"title": @"Multiple Lines Chart 多行图表",
                          @"subtitle": @"A line chart with multiple DataSet objects. One color per DataSet. 具有多个DataSet对象的折线图。每个数据集一种颜色。",
                          @"class": MultipleLinesChartViewController.class
                          },
                      @{
                          @"title": @"Multiple Bars Chart 多条形图",
                          @"subtitle": @"A bar chart with multiple DataSet objects. One multiple colors per DataSet. 具有多个DataSet对象的条形图。每个数据集有多种颜色。",
                          @"class": MultipleBarChartViewController.class
                          },
                      @{
                          @"title": @"Candle Stick Chart 蜡烛棒图",
                          @"subtitle": @"Demonstrates usage of the CandleStickChart. 演示CandleStickChart的用法",
                          @"class": CandleStickChartViewController.class
                          },
                      @{
                          @"title": @"Cubic Line Chart 立方线图",
                          @"subtitle": @"Demonstrates cubic lines in a LineChart. 演示LineChart中的立方线。",
                          @"class": CubicLineChartViewController.class
                          },
                      @{
                          @"title": @"Radar Chart 雷达图",
                          @"subtitle": @"Demonstrates the use of a spider-web like (net) chart. 演示如何使用类似蜘蛛网的（网络）图表。",
                          @"class": RadarChartViewController.class
                          },
                      @{
                          @"title": @"Colored Line Chart 彩色折线图",
                          @"subtitle": @"Shows a LineChart with different background and line color. 显示具有不同背景和线条颜色的线条图。",
                          @"class": ColoredLineChartViewController.class
                          },
                      @{
                          @"title": @"Sinus Bar Chart 正弦条形图",
                          @"subtitle": @"A Bar Chart plotting the sinus function with 8.000 values. 用8.000值绘制正弦函数的条形图。",
                          @"class": SinusBarChartViewController.class
                          },
                      @{
                          
                          @"title": @"BarChart positive / negative 条形图正/负",
                          @"subtitle": @"This demonstrates how to create a BarChart with positive and negative values in different colors. 这演示了如何使用不同颜色的正值和负值创建BarChart",
                          @"class": PositiveNegativeBarChartViewController.class
                          },
                      @{
                          
                          @"title": @"Time Line Chart 时间线图",
                          @"subtitle": @"Simple demonstration of a time-chart. This chart draws one line entry per hour originating from the current time in milliseconds. 时间图的简单演示。此图表以毫秒为单位从当前时间开始，每小时绘制一行条目。",
                          @"class": LineChartTimeViewController.class
                          },
                      @{
                          
                          @"title": @"Filled Line Chart 填充折线图",
                          @"subtitle": @"This demonstrates how to fill an area between two LineDataSets. 这演示了如何填充两个LineDataSet之间的区域。",
                          @"class": LineChartFilledViewController.class
                          },
                      @{
                          
                          @"title": @"Half Pie Chart 半饼图",
                          @"subtitle": @"This demonstrates how to create a 180 degree PieChart.这将演示如何创建180度饼图。",
                          @"class": HalfPieChartViewController.class
                          }
                      ];
    //FIXME: Add TimeLineChart
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemDefs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *def = self.itemDefs[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = def[@"title"];
    cell.detailTextLabel.text = def[@"subtitle"];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *def = self.itemDefs[indexPath.row];
    
    Class vcClass = def[@"class"];
    UIViewController *vc = [[vcClass alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
