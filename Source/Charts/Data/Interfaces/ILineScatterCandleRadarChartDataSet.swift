//
//  ILineScatterCandleRadarChartDataSet.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

@objc
public protocol ILineScatterCandleRadarChartDataSet: IBarLineScatterCandleBubbleChartDataSet
{
    // MARK: - Data functions and accessors
    
    // MARK: - Styling functions and accessors
    
    /// Enables / disables the horizontal highlight-indicator. If disabled, the indicator is not drawn.
    /// 启用/禁用水平高亮显示指示器。如果禁用，则不绘制指示器。
    var drawHorizontalHighlightIndicatorEnabled: Bool { get set }
    
    /// Enables / disables the vertical highlight-indicator. If disabled, the indicator is not drawn.
    /// 启用/禁用垂直高亮显示指示器。如果禁用，则不绘制指示器。
    var drawVerticalHighlightIndicatorEnabled: Bool { get set }
    
    /// `true` if horizontal highlight indicator lines are enabled (drawn)
    /// `true`如果启用（绘制）水平突出显示指示线
    var isHorizontalHighlightIndicatorEnabled: Bool { get }
    
    /// `true` if vertical highlight indicator lines are enabled (drawn)
    /// `true`如果启用（绘制）垂直高亮显示指示线
    var isVerticalHighlightIndicatorEnabled: Bool { get }
    
    /// Enables / disables both vertical and horizontal highlight-indicators.
    /// 启用/禁用垂直和水平突出显示指示器。
    /// :param: enabled
    func setDrawHighlightIndicators(_ enabled: Bool)
}
