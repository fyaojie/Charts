//
//  ChartDataProvider.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc
public protocol ChartDataProvider
{
    /// The minimum x-value of the chart, regardless of zoom or translation.
    /// 图表的最小x值，与缩放或平移无关。
    var chartXMin: Double { get }
    
    /// The maximum x-value of the chart, regardless of zoom or translation.
    /// 图表的最大x值，与缩放或平移无关。
    var chartXMax: Double { get }
    
    /// The minimum y-value of the chart, regardless of zoom or translation.
    /// 图表的最小y值，与缩放或平移无关。
    var chartYMin: Double { get }
    
    /// The maximum y-value of the chart, regardless of zoom or translation.
    /// 图表的最大y值，不考虑缩放或平移。
    var chartYMax: Double { get }
    
    /// 最大高亮显示距离
    var maxHighlightDistance: CGFloat { get }
    
    var xRange: Double { get }
    
    var centerOffsets: CGPoint { get }
    
    var data: ChartData? { get }
    
    var maxVisibleCount: Int { get }
}
