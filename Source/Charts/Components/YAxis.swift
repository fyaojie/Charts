//
//  YAxis.swift
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

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif


/// Class representing the y-axis labels settings and its entries.
/// 类，表示y轴标签设置及其条目。
/// Be aware that not all features the YLabels class provides are suitable for the RadarChart.
/// 请注意，并不是YLabels类提供的所有特性都适合RadarChart。
/// Customizations that affect the value range of the axis need to be applied before setting data for the chart.
/// 在设置图表数据之前，需要应用影响轴值范围的自定义设置。
@objc(ChartYAxis)
open class YAxis: AxisBase
{
    @objc(YAxisLabelPosition)
    public enum LabelPosition: Int
    {
        case outsideChart
        case insideChart
    }
    
    ///  Enum that specifies the axis a DataSet should be plotted against, either Left or Right.
    ///  枚举，该枚举指定数据集应绘制的轴（左或右）。
    @objc
    public enum AxisDependency: Int
    {
        case left
        case right
    }
    
    /// indicates if the bottom y-label entry is drawn or not
    /// 指示是否绘制底部y标签条目
    @objc open var drawBottomYLabelEntryEnabled = true
    
    /// indicates if the top y-label entry is drawn or not
    /// 指示是否绘制了顶部y标签条目
    @objc open var drawTopYLabelEntryEnabled = true
    
    /// flag that indicates if the axis is inverted or not
    /// 指示轴是否反转的标志
    @objc open var inverted = false
    
    /// flag that indicates if the zero-line should be drawn regardless of other grid lines
    /// 指示是否应绘制零线而不管其他网格线的标志
    @objc open var drawZeroLineEnabled = false
    
    /// Color of the zero line
    /// 零线的颜色
    @objc open var zeroLineColor: NSUIColor? = NSUIColor.gray
    
    /// Width of the zero line
    /// 零线的宽度
    @objc open var zeroLineWidth: CGFloat = 1.0
    
    /// This is how much (in pixels) into the dash pattern are we starting from.
    /// 这是我们从虚线模式开始的数量（以像素为单位）。
    @objc open var zeroLineDashPhase = CGFloat(0.0)
    
    /// This is the actual dash pattern. 这是实际的虚线图案。
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    @objc open var zeroLineDashLengths: [CGFloat]?

    /// axis space from the largest value to the top in percent of the total axis range
    /// 从最大值到顶部的轴空间，占总轴范围的百分比
    @objc open var spaceTop = CGFloat(0.1)

    /// axis space from the smallest value to the bottom in percent of the total axis range
    /// 从最小值到底部的轴空间，占总轴范围的百分比
    @objc open var spaceBottom = CGFloat(0.1)
    
    /// the position of the y-labels relative to the chart
    /// y标签相对于图表的位置
    @objc open var labelPosition = LabelPosition.outsideChart

    /// the alignment of the text in the y-label
    /// y标签中文本的对齐方式
    @objc open var labelAlignment: NSTextAlignment = .left

    /// the horizontal offset of the y-label
    /// y标签的水平偏移
    @objc open var labelXOffset: CGFloat = 0.0
    
    /// the side this axis object represents
    /// 此轴对象表示的一侧
    private var _axisDependency = AxisDependency.left
    
    /// the minimum width that the axis should take
    /// 轴应采用的最小宽度
    /// **default**: 0.0
    @objc open var minWidth = CGFloat(0)
    
    /// the maximum width that the axis can take.
    /// 轴可以采用的最大宽度。
    /// use Infinity for disabling the maximum.
    /// 使用Infinity禁用最大值。
    /// **default**: CGFloat.infinity
    @objc open var maxWidth = CGFloat(CGFloat.infinity)
    
    public override init()
    {
        super.init()
        
        self.yOffset = 0.0
    }
    
    @objc public init(position: AxisDependency)
    {
        super.init()
        
        _axisDependency = position
        
        self.yOffset = 0.0
    }
    
    @objc open var axisDependency: AxisDependency
    {
        return _axisDependency
    }
    
    @objc open func requiredSize() -> CGSize
    {
        let label = getLongestLabel() as NSString
        var size = label.size(withAttributes: [NSAttributedString.Key.font: labelFont])
        size.width += xOffset * 2.0
        size.height += yOffset * 2.0
        size.width = max(minWidth, min(size.width, maxWidth > 0.0 ? maxWidth : size.width))
        return size
    }
    
    @objc open func getRequiredHeightSpace() -> CGFloat
    {
        return requiredSize().height
    }
    
    /// `true` if this axis needs horizontal offset, `false` ifno offset is needed.
    /// `true'如果此轴需要水平偏移，如果不需要偏移，则为'false'。
    @objc open var needsOffset: Bool
    {
        if isEnabled && isDrawLabelsEnabled && labelPosition == .outsideChart
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    @objc open var isInverted: Bool { return inverted }
    
    open override func calculate(min dataMin: Double, max dataMax: Double)
    {
        // if custom, use value as is, else use data value
        /// 如果自定义，则按原样使用值，否则使用数据值
        var min = _customAxisMin ? _axisMinimum : dataMin
        var max = _customAxisMax ? _axisMaximum : dataMax
        
        // Make sure max is greater than min
        /// 确保最大值大于最小值
        // Discussion: https://github.com/danielgindi/Charts/pull/3650#discussion_r221409991
        if min > max
        {
            switch(_customAxisMax, _customAxisMin)
            {
            case(true, true):
                (min, max) = (max, min)
            case(true, false):
                min = max < 0 ? max * 1.5 : max * 0.5
            case(false, true):
                max = min < 0 ? min * 0.5 : min * 1.5
            case(false, false):
                break
            }
        }
        
        // temporary range (before calculations)
        /// 临时范围（计算前）
        let range = abs(max - min)
        
        // in case all values are equal
        /// 如果所有值相等
        if range == 0.0
        {
            max = max + 1.0
            min = min - 1.0
        }
        
        // bottom-space only effects non-custom min
        /// 底部空间仅影响非自定义最小值
        if !_customAxisMin
        {
            let bottomSpace = range * Double(spaceBottom)
            _axisMinimum = (min - bottomSpace)
        }
        
        // top-space only effects non-custom max
        /// 顶部空间仅影响非自定义最大值
        if !_customAxisMax
        {
            let topSpace = range * Double(spaceTop)
            _axisMaximum = (max + topSpace)
        }
        
        // calc actual range
        /// 计算实际范围
        axisRange = abs(_axisMaximum - _axisMinimum)
    }
    
    @objc open var isDrawBottomYLabelEntryEnabled: Bool { return drawBottomYLabelEntryEnabled }
    
    @objc open var isDrawTopYLabelEntryEnabled: Bool { return drawTopYLabelEntryEnabled }

}
