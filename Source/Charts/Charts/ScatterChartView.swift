//
//  ScatterChartView.swift
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

/// The ScatterChart. Draws dots, triangles, squares and custom shapes into the chartview.
/// 散点图。在图表视图中绘制点、三角形、正方形和自定义形状。
open class ScatterChartView: BarLineChartViewBase, ScatterChartDataProvider
{
    open override func initialize()
    {
        super.initialize()
        
        renderer = ScatterChartRenderer(dataProvider: self, animator: chartAnimator, viewPortHandler: viewPortHandler)

        xAxis.spaceMin = 0.5
        xAxis.spaceMax = 0.5
    }
    
    // MARK: - ScatterChartDataProvider
    
    open var scatterData: ScatterChartData? { return data as? ScatterChartData }
}
