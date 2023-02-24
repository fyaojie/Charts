//
//  ChartLimitLine.swift
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


/// The limit line is an additional feature for all Line, Bar and ScatterCharts.
/// 限制线是所有折线图、条形图和散点图的附加功能。
/// It allows the displaying of an additional line in the chart that marks a certain maximum / limit on the specified axis (x- or y-axis).
/// 它允许在图表中显示一条额外的线，该线标记指定轴（x轴或y轴）上的某个最大值/限制。
open class ChartLimitLine: ComponentBase
{
    @objc(ChartLimitLabelPosition)
    public enum LabelPosition: Int
    {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    /// limit / maximum (the y-value or xIndex)
    /// 极限/最大值（y值或xIndex）
    @objc open var limit = Double(0.0)
    
    private var _lineWidth = CGFloat(2.0)
    @objc open var lineColor = NSUIColor(red: 237.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0)
    @objc open var lineDashPhase = CGFloat(0.0)
    @objc open var lineDashLengths: [CGFloat]?
    
    @objc open var valueTextColor = NSUIColor.labelOrBlack
    @objc open var valueFont = NSUIFont.systemFont(ofSize: 13.0)
    
    @objc open var drawLabelEnabled = true
    @objc open var label = ""
    @objc open var labelPosition = LabelPosition.topRight
    
    public override init()
    {
        super.init()
    }
    
    @objc public init(limit: Double)
    {
        super.init()
        self.limit = limit
    }
    
    @objc public init(limit: Double, label: String)
    {
        super.init()
        self.limit = limit
        self.label = label
    }
    
    /// set the line width of the chart (min = 0.2, max = 12); default 2
    /// 设置图表的线宽（min=0.2，max=12）；默认值2
    @objc open var lineWidth: CGFloat
    {
        get
        {
            return _lineWidth
        }
        set
        {
            _lineWidth = newValue.clamped(to: 0.2...12)
        }
    }
}
