//
//  Transformer.swift
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

/// Transformer class that contains all matrices and is responsible for transforming values into pixels on the screen and backwards.
/// Transformer类，它包含所有矩阵，负责将值转换为屏幕上的像素并向后转换。
@objc(ChartTransformer)
open class Transformer: NSObject
{
    /// matrix to map the values to the screen pixels
    /// 矩阵将值映射到屏幕像素
    internal var matrixValueToPx = CGAffineTransform.identity

    /// matrix for handling the different offsets of the chart
    /// 用于处理图表不同偏移量的矩阵
    internal var matrixOffset = CGAffineTransform.identity

    internal var viewPortHandler: ViewPortHandler

    @objc public init(viewPortHandler: ViewPortHandler)
    {
        self.viewPortHandler = viewPortHandler
    }

    /// Prepares the matrix that transforms values to pixels. Calculates the scale factors from the charts size and offsets.
    /// 准备将值转换为像素的矩阵。根据图表大小和偏移量计算比例因子。
    @objc open func prepareMatrixValuePx(chartXMin: Double, deltaX: CGFloat, deltaY: CGFloat, chartYMin: Double)
    {
        var scaleX = (viewPortHandler.contentWidth / deltaX)
        var scaleY = (viewPortHandler.contentHeight / deltaY)
        
        if .infinity == scaleX
        {
            scaleX = 0.0
        }
        if .infinity == scaleY
        {
            scaleY = 0.0
        }

        /// setup all matrices
        /// 设置所有矩阵
        matrixValueToPx = CGAffineTransform.identity
            .scaledBy(x: scaleX, y: -scaleY)
            .translatedBy(x: CGFloat(-chartXMin), y: CGFloat(-chartYMin))
    }

    /// Prepares the matrix that contains all offsets.
    /// 准备包含所有偏移量的矩阵。
    @objc open func prepareMatrixOffset(inverted: Bool)
    {
        if !inverted
        {
            matrixOffset = CGAffineTransform(translationX: viewPortHandler.offsetLeft, y: viewPortHandler.chartHeight - viewPortHandler.offsetBottom)
        }
        else
        {
            matrixOffset = CGAffineTransform(scaleX: 1.0, y: -1.0)
                .translatedBy(x: viewPortHandler.offsetLeft, y: -viewPortHandler.offsetTop)
        }
    }

    /// Transform an array of points with all matrices.
    /// 使用所有矩阵变换点阵列。
    /// VERY IMPORTANT: Keep matrix order "value-touch-offset" when transforming.
    /// 非常重要：变换时保持矩阵顺序“值接触偏移”。
    open func pointValuesToPixel(_ points: inout [CGPoint])
    {
        let trans = valueToPixelMatrix
        points = points.map { $0.applying(trans) }
    }
    
    open func pointValueToPixel(_ point: inout CGPoint)
    {
        point = point.applying(valueToPixelMatrix)
    }
    
    @objc open func pixelForValues(x: Double, y: Double) -> CGPoint
    {
        return CGPoint(x: x, y: y).applying(valueToPixelMatrix)
    }
    
    /// Transform a rectangle with all matrices.
    /// 用所有矩阵变换矩形。
    open func rectValueToPixel(_ r: inout CGRect)
    {
        r = r.applying(valueToPixelMatrix)
    }
    
    /// Transform a rectangle with all matrices with potential animation phases.
    /// 使用具有潜在动画阶段的所有矩阵变换矩形。
    open func rectValueToPixel(_ r: inout CGRect, phaseY: Double)
    {
        // multiply the height of the rect with the phase 将矩形的高度乘以相位
        var bottom = r.origin.y + r.size.height
        bottom *= CGFloat(phaseY)
        let top = r.origin.y * CGFloat(phaseY)
        r.size.height = bottom - top
        r.origin.y = top

        r = r.applying(valueToPixelMatrix)
    }
    
    /// Transform a rectangle with all matrices.
    /// 用所有矩阵变换矩形。
    open func rectValueToPixelHorizontal(_ r: inout CGRect)
    {
        r = r.applying(valueToPixelMatrix)
    }
    
    /// Transform a rectangle with all matrices with potential animation phases.
    /// 使用具有潜在动画阶段的所有矩阵变换矩形。
    open func rectValueToPixelHorizontal(_ r: inout CGRect, phaseY: Double)
    {
        // multiply the height of the rect with the phase
        let left = r.origin.x * CGFloat(phaseY)
        let right = (r.origin.x + r.size.width) * CGFloat(phaseY)
        r.size.width = right - left
        r.origin.x = left
        
        r = r.applying(valueToPixelMatrix)
    }

    /// transforms multiple rects with all matrices
    /// 用所有矩阵变换多个矩形
    open func rectValuesToPixel(_ rects: inout [CGRect])
    {
        let trans = valueToPixelMatrix
        rects = rects.map { $0.applying(trans) }
    }
    
    /// Transforms the given array of touch points (pixels) into values on the chart.
    /// 将给定的触摸点阵列（像素）转换为图表上的值。
    open func pixelsToValues(_ pixels: inout [CGPoint])
    {
        let trans = pixelToValueMatrix
        pixels = pixels.map { $0.applying(trans) }
    }
    
    /// Transforms the given touch point (pixels) into a value on the chart.
    /// 将给定的触摸点（像素）转换为图表上的值。
    open func pixelToValues(_ pixel: inout CGPoint)
    {
        pixel = pixel.applying(pixelToValueMatrix)
    }
    
    /// - Returns: The x and y values in the chart at the given touch point
    /// (encapsulated in a CGPoint). This method transforms pixel coordinates to
    /// coordinates / values in the chart.
    /// 图表中给定触摸点的x和y值（封装在CGPoint中）。此方法将像素坐标转换为图表中的坐标/值。
    @objc open func valueForTouchPoint(_ point: CGPoint) -> CGPoint
    {
        return point.applying(pixelToValueMatrix)
    }
    
    /// - Returns: The x and y values in the chart at the given touch point
    /// (x/y). This method transforms pixel coordinates to
    /// coordinates / values in the chart.
    /// 图表中给定接触点（x/y）处的x和y值。此方法将像素坐标转换为图表中的坐标/值。
    @objc open func valueForTouchPoint(x: CGFloat, y: CGFloat) -> CGPoint
    {
        return CGPoint(x: x, y: y).applying(pixelToValueMatrix)
    }
    
    /**
     在iOS中，级联方法用于将两个CGAffineTransform结构组合成一个结构。CGAffineTransform结构表示可用于变换点、大小和矩形的2D仿射变换矩阵。

     串联方法将第二个CGAffineTransform结构t2作为输入，并返回表示两个原始变换的组合的新CGAffineTransform结构。

     下面是如何使用串联方法的示例：
     let transform1 = CGAffineTransform(scaleX: 2, y: 2)
     let transform2 = CGAffineTransform(translationX: 100, y: 100)
     let combinedTransform = transform1.concatenating(transform2)

     在此示例中，transform1将点的x和y坐标缩放2倍，transform2将x和y的坐标平移100个单位。combinedTransform变量保存连接这两个变换的结果，因此它表示先缩放然后平移的变换。
     */
    
    @objc open var valueToPixelMatrix: CGAffineTransform
    {
        return
            matrixValueToPx.concatenating(viewPortHandler.touchMatrix)
                .concatenating(matrixOffset
        )
    }
    
    /**
     方法inverted（）是苹果iOS和macOS平台的核心图形框架中使用的方法。它返回一个新的CGAffineTransform，它是当前变换矩阵的逆。逆变换会反转原始变换的效果，允许您撤消变换并将对象返回到其原始状态。这对于撤消变换或从一个坐标系转换到另一个坐标系统非常有用。
     */
    @objc open var pixelToValueMatrix: CGAffineTransform
    {
        return valueToPixelMatrix.inverted()
    }
}
