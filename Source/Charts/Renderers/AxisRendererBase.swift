//
//  AxisRendererBase.swift
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

@objc(ChartAxisRendererBase)
open class AxisRendererBase: Renderer
{
    /// base axis this axis renderer works with
    /// 此轴渲染器使用的基准轴
    @objc open var axis: AxisBase?
    
    /// transformer to transform values to screen pixels and return
    @objc open var transformer: Transformer?

    @objc public init(viewPortHandler: ViewPortHandler, transformer: Transformer?, axis: AxisBase?)
    {
        super.init(viewPortHandler: viewPortHandler)
        
        self.transformer = transformer
        self.axis = axis
    }
    
    /// Draws the axis labels on the specified context
    @objc open func renderAxisLabels(context: CGContext)
    {
        fatalError("renderAxisLabels() cannot be called on AxisRendererBase")
    }
    
    /// Draws the grid lines belonging to the axis.
    @objc open func renderGridLines(context: CGContext)
    {
        fatalError("renderGridLines() cannot be called on AxisRendererBase")
    }
    
    /// Draws the line that goes alongside the axis.
    @objc open func renderAxisLine(context: CGContext)
    {
        fatalError("renderAxisLine() cannot be called on AxisRendererBase")
    }
    
    /// Draws the LimitLines associated with this axis to the screen.
    @objc open func renderLimitLines(context: CGContext)
    {
        fatalError("renderLimitLines() cannot be called on AxisRendererBase")
    }
    
    /// Computes the axis values. 计算轴值。
    ///
    /// - Parameters:
    ///   - min: the minimum value in the data object for this axis 此轴的数据对象中的最小值
    ///   - max: the maximum value in the data object for this axis 此轴的数据对象中的最大值
    ///   - inverted: 倒转
    @objc open func computeAxis(min: Double, max: Double, inverted: Bool)
    {
        var min = min, max = max
        
        if let transformer = self.transformer
        {
            /// calculate the starting and entry point of the y-labels (depending on zoom / contentrect bounds)
            /// 计算y标签的起点和入口点（取决于缩放/内容矩形边界）
            if viewPortHandler.contentWidth > 10.0 && !viewPortHandler.isFullyZoomedOutY
            {
                /// 视图坐标转换为图表坐标
                let p1 = transformer.valueForTouchPoint(CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentTop))
                let p2 = transformer.valueForTouchPoint(CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom))
                
                if !inverted
                {
                    min = Double(p2.y)
                    max = Double(p1.y)
                }
                else
                {
                    min = Double(p1.y)
                    max = Double(p2.y)
                }
            }
        }
        
        computeAxisValues(min: min, max: max)
    }
    
    /// Sets up the axis values. Computes the desired number of labels between the two given extremes.
    /// 设置轴值。计算两个给定极值之间所需的标签数。
    @objc open func computeAxisValues(min: Double, max: Double)
    {
        guard let axis = self.axis else { return }
        
        let yMin = min
        let yMax = max
        
        let labelCount = axis.labelCount
        let range = abs(yMax - yMin)
        
        if labelCount == 0 || range <= 0 || range.isInfinite
        {
            axis.entries = [Double]()
            axis.centeredEntries = [Double]()
            return
        }
        
        /// Find out how much spacing (in y value space) between axis values
        /// 找出轴值之间的间距（在y值空间中）
        let rawInterval = range / Double(labelCount)
        /// 取相近的整数, 间距
        var interval = rawInterval.roundedToNextSignificant()
        
        /// If granularity is enabled, then do not allow the interval to go below specified granularity.
        /// 如果启用了粒度，则不允许间隔低于指定的粒度。
        /// This is used to avoid repeated values when rounding values for display.
        /// 这用于在舍入显示值时避免重复值。
        if axis.granularityEnabled
        {
            interval = interval < axis.granularity ? axis.granularity : interval
        }
        
        /// Normalize interval
        /// 规格化间隔
        let intervalMagnitude = pow(10.0, Double(Int(log10(interval)))).roundedToNextSignificant()
        let intervalSigDigit = Int(interval / intervalMagnitude)
        if intervalSigDigit > 5
        {
            // Use one order of magnitude higher, to avoid intervals like 0.9 or 90
            /// 使用高一个数量级，以避免0.9或90
            // if it's 0.0 after floor(), we use the old value
            /// 如果floor（）之后为0.0，则使用旧值
            interval = floor(10.0 * intervalMagnitude) == 0.0 ? interval : floor(10.0 * intervalMagnitude)
        }
        
        var n = axis.centerAxisLabelsEnabled ? 1 : 0
        
        // force label count
        /// 强制标签计数
        if axis.isForceLabelsEnabled
        {
            interval = Double(range) / Double(labelCount - 1)
            
            // Ensure stops contains at least n elements.
            /// 确保挡块至少包含n个元素。
            axis.entries.removeAll(keepingCapacity: true)
            axis.entries.reserveCapacity(labelCount)
            
            var v = yMin
            
            for _ in 0 ..< labelCount
            {
                axis.entries.append(v)
                v += interval
            }
            
            n = labelCount
        }
        else
        {
            // no forced count
            /// 无强制计数
            var first = interval == 0.0 ? 0.0 : ceil(yMin / interval) * interval
            
            if axis.centerAxisLabelsEnabled
            {
                first -= interval
            }
            /// nextUp 大于此值的最小可表示值。
            let last = interval == 0.0 ? 0.0 : (floor(yMax / interval) * interval).nextUp
            
            if interval != 0.0 && last != first
            {
                for _ in stride(from: first, through: last, by: interval)
                {
                    n += 1
                }
            }
            else if last == first && n == 0
            {
                n = 1
            }

            // Ensure stops contains at least n elements.
            axis.entries.removeAll(keepingCapacity: true)
            axis.entries.reserveCapacity(labelCount)
            
            var f = first
            var i = 0
            while i < n
            {
                if f == 0.0
                {
                    // Fix for IEEE negative zero case (Where value == -0.0, and 0.0 == -0.0)
                    /// 修复IEEE负零情况（其中值==0.0，0.0==0.0）
                    f = 0.0
                }
                
                axis.entries.append(Double(f))
                
                f += interval
                i += 1
            }
        }
        
        // set decimals
        /// 集合小数
        if interval < 1
        {
            axis.decimals = Int(ceil(-log10(interval)))
        }
        else
        {
            axis.decimals = 0
        }
        
        if axis.centerAxisLabelsEnabled
        {
            axis.centeredEntries.reserveCapacity(n)
            axis.centeredEntries.removeAll()
            
            let offset: Double = interval / 2.0
            
            for i in 0 ..< n
            {
                axis.centeredEntries.append(axis.entries[i] + offset)
            }
        }
    }
}
