//
//  ChartMarker.swift
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

@objc(IChartMarker)
public protocol IMarker: class
{
    /// - Returns: The desired (general) offset you wish the IMarker to have on the x-axis.
    /// 您希望I标记在x轴上具有的所需（常规）偏移。
    /// By returning x: -(width / 2) you will center the IMarker horizontally.
    /// By returning y: -(height / 2) you will center the IMarker vertically.
    var offset: CGPoint { get }
    
    /// - Parameters:
    ///   - point: This is the point at which the marker wants to be drawn. You can adjust the offset conditionally based on this argument.
    ///   这是要绘制标记的点。可以根据此参数有条件地调整偏移量。
    /// - Returns: The offset for drawing at the specific `point`.
    ///            This allows conditional adjusting of the Marker position.
    ///            If you have no adjustments to make, return self.offset().
    ///            在特定“点”绘制的偏移量。 这允许有条件地调整标记位置。 如果没有调整，请返回self.offset（）。
    func offsetForDrawing(atPoint: CGPoint) -> CGPoint
    
    /// This method enables a custom IMarker to update it's content every time the IMarker is redrawn according to the data entry it points to.
    /// 此方法允许自定义IMarker在每次根据其指向的数据条目重新绘制IMarker时更新其内容。
    /// - Parameters:
    ///   - entry: The Entry the IMarker belongs to. This can also be any subclass of Entry, like BarEntry or CandleEntry, simply cast it at runtime.
    ///   IMarker所属的Entry。这也可以是Entry的任何子类，如BarEntry或CandleEntry，只需在运行时将其强制转换。
    ///   - highlight: The highlight object contains information about the highlighted value such as it's dataset-index, the selected range or stack-index (only stacked bar entries).
    ///   高亮显示对象包含有关高亮显示值的信息，例如其数据集索引、选定范围或堆栈索引（仅堆叠条形图条目）。
    func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    
    /// Draws the IMarker on the given position on the given context
    /// 在给定上下文的给定位置上绘制IMarker
    func draw(context: CGContext, point: CGPoint)
}
