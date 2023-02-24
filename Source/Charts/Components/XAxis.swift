//
//  XAxis.swift
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

@objc(ChartXAxis)
open class XAxis: AxisBase
{
    @objc(XAxisLabelPosition)
    public enum LabelPosition: Int
    {
        case top
        case bottom
        case bothSided
        case topInside
        case bottomInside
    }
    
    /// width of the x-axis labels in pixels - this is automatically calculated by the `computeSize()` methods in the renderers
    /// x轴标签的宽度（以像素为单位）-这由渲染器中的“computeSize（）”方法自动计算
    @objc open var labelWidth = CGFloat(1.0)
    
    /// height of the x-axis labels in pixels - this is automatically calculated by the `computeSize()` methods in the renderers
    /// x轴标签的高度（以像素为单位）-这由渲染器中的“computeSize（）”方法自动计算
    @objc open var labelHeight = CGFloat(1.0)
    
    /// width of the (rotated) x-axis labels in pixels - this is automatically calculated by the `computeSize()` methods in the renderers
    /// （旋转的）x轴标签的宽度（以像素为单位）-这由渲染器中的“computeSize（）”方法自动计算
    @objc open var labelRotatedWidth = CGFloat(1.0)
    
    /// height of the (rotated) x-axis labels in pixels - this is automatically calculated by the `computeSize()` methods in the renderers
    /// （旋转的）x轴标签的高度（以像素为单位）-这由渲染器中的“computeSize（）”方法自动计算
    @objc open var labelRotatedHeight = CGFloat(1.0)
    
    /// This is the angle for drawing the X axis labels (in degrees)
    /// 这是绘制X轴标签的角度（以度为单位）
    @objc open var labelRotationAngle = CGFloat(0.0)

    /// if set to true, the chart will avoid that the first and last label entry in the chart "clip" off the edge of the chart
    /// 如果设置为true，图表将避免图表中的第一个和最后一个标签条目从图表边缘“剪切”
    @objc open var avoidFirstLastClippingEnabled = false
    
    /// the position of the x-labels relative to the chart
    /// x标签相对于图表的位置
    @objc open var labelPosition = LabelPosition.top
    
    /// if set to true, word wrapping the labels will be enabled.
    /// 如果设置为true，将启用对标签的换行。
    /// word wrapping is done using `(value width * labelRotatedWidth)`
    /// 单词换行使用`（value width*labelRotatedWidth）`
    /// - Note: currently supports all charts except pie/radar/horizontal-bar*
    /// 当前支持除饼图/雷达图/水平条之外的所有图表
    @objc open var wordWrapEnabled = false
    
    /// `true` if word wrapping the labels is enabled
    /// `true`如果启用了文字包装标签
    @objc open var isWordWrapEnabled: Bool { return wordWrapEnabled }
    
    /// the width for wrapping the labels, as percentage out of one value width.
    /// 包装标签的宽度，以一个值宽度的百分比表示。
    /// used only when isWordWrapEnabled = true.
    ///  仅当isWordWrapEnabled=true时使用。
    /// **default**: 1.0
    @objc open var wordWrapWidthPercent: CGFloat = 1.0
    
    public override init()
    {
        super.init()
        
        self.yOffset = 4.0
    }
    
    /// 已启用避免首个最后一个剪辑
    @objc open var isAvoidFirstLastClippingEnabled: Bool
    {
        return avoidFirstLastClippingEnabled
    }
}
