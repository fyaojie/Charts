//
//  Fill.swift
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

@objc(ChartFill)
public protocol Fill
{

    /// Draws the provided path in filled mode with the provided area
    /// 使用提供的区域以填充模式绘制提供的路径
    @objc func fillPath(context: CGContext, rect: CGRect)
}

@objc(ChartEmptyFill)
public class EmptyFill: NSObject, Fill
{

    public func fillPath(context: CGContext, rect: CGRect) { }
}

@objc(ChartColorFill)
public class ColorFill: NSObject, Fill
{

    @objc public let color: CGColor

    @objc public init(cgColor: CGColor)
    {
        self.color = cgColor
        super.init()
    }

    @objc public convenience init(color: NSUIColor)
    {
        self.init(cgColor: color.cgColor)
    }

    public func fillPath(context: CGContext, rect: CGRect)
    {
        /// 入栈
        context.saveGState()
        /// 出栈
        defer { context.restoreGState() }

        /// 颜色填充
        context.setFillColor(color)
        context.fillPath()
    }
}

@objc(ChartImageFill)
public class ImageFill: NSObject, Fill
{

    @objc public let image: CGImage
    @objc public let isTiled: Bool /// 是否平铺

    @objc public init(cgImage: CGImage, isTiled: Bool = false)
    {
        image = cgImage
        self.isTiled = isTiled
        super.init()
    }

    @objc public convenience init(image: NSUIImage, isTiled: Bool = false)
    {
        self.init(cgImage: image.cgImage!, isTiled: isTiled)
    }

    public func fillPath(context: CGContext, rect: CGRect)
    {
        context.saveGState()
        /***
         "defer"是Swift语言中的一个关键字，用于在代码块结束时执行特定的清理操作。它与"try"和"catch"一起使用，用于处理可能出现的错误。
         当代码块结束时，defer语句中的清理操作将被自动执行，无论代码块中是否发生错误。因此，defer语句常用于在代码块中打开文件、分配资源等，以确保在代码块结束时及时释放资源。
         */
        defer { context.restoreGState() }

        context.clip()
        context.draw(image, in: rect, byTiling: isTiled)
    }
}

@objc(ChartLayerFill)
public class LayerFill: NSObject, Fill
{

    @objc public let layer: CGLayer

    @objc public init(layer: CGLayer)
    {
        self.layer = layer
        super.init()
    }

    public func fillPath(context: CGContext, rect: CGRect)
    {
        context.saveGState()
        defer { context.restoreGState() }

        /**
         在调用context.draw(layer, in: rect)之前调用context.clip()是因为裁剪操作限制了绘图的范围，只有在裁剪范围内的图形才会被绘制。因此，如果在调用context.draw(layer, in: rect)之前不进行裁剪，整个layer可能会被绘制到屏幕上，而不是仅绘制rect指定的范围。因此，裁剪可以限制绘制范围，并确保只绘制所需的图形。
         */
        context.clip()
        context.draw(layer, in: rect)
    }
}

@objc(ChartLinearGradientFill)
public class LinearGradientFill: NSObject, Fill /// 线性渐变
{

    @objc public let gradient: CGGradient
    @objc public let angle: CGFloat

    @objc public init(gradient: CGGradient, angle: CGFloat = 0)
    {
        self.gradient = gradient
        self.angle = angle
        super.init()
    }

    public func fillPath(context: CGContext, rect: CGRect)
    {
        context.saveGState()
        defer { context.restoreGState() }

        let radians = (360.0 - angle).DEG2RAD
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        let xAngleDelta = cos(radians) * rect.width / 2.0
        let yAngleDelta = sin(radians) * rect.height / 2.0
        let startPoint = CGPoint(
            x: centerPoint.x - xAngleDelta,
            y: centerPoint.y - yAngleDelta
        )
        let endPoint = CGPoint(
            x: centerPoint.x + xAngleDelta,
            y: centerPoint.y + yAngleDelta
        )

        context.clip()
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
        )
    }
}

@objc(ChartRadialGradientFill)
public class RadialGradientFill: NSObject, Fill
{

    @objc public let gradient: CGGradient
    @objc public let startOffsetPercent: CGPoint
    @objc public let endOffsetPercent: CGPoint
    @objc public let startRadiusPercent: CGFloat
    @objc public let endRadiusPercent: CGFloat

    @objc public init(
        gradient: CGGradient,
        startOffsetPercent: CGPoint,
        endOffsetPercent: CGPoint,
        startRadiusPercent: CGFloat,
        endRadiusPercent: CGFloat)
    {
        self.gradient = gradient
        self.startOffsetPercent = startOffsetPercent
        self.endOffsetPercent = endOffsetPercent
        self.startRadiusPercent = startRadiusPercent
        self.endRadiusPercent = endRadiusPercent
        super.init()
    }

    @objc public convenience init(gradient: CGGradient)
    {
        self.init(
            gradient: gradient,
            startOffsetPercent: .zero,
            endOffsetPercent: .zero,
            startRadiusPercent: 0,
            endRadiusPercent: 1
        )
    }

    @objc public func fillPath(context: CGContext, rect: CGRect)
    {
        context.saveGState()
        defer { context.restoreGState() }

        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.height) / 2.0

        context.clip()
        context.drawRadialGradient(
            gradient,
            startCenter: CGPoint(
                x: centerPoint.x + rect.width * startOffsetPercent.x,
                y: centerPoint.y + rect.height * startOffsetPercent.y
            ),
            startRadius: radius * startRadiusPercent,
            endCenter: CGPoint(
                x: centerPoint.x + rect.width * endOffsetPercent.x,
                y: centerPoint.y + rect.height * endOffsetPercent.y
            ),
            endRadius: radius * endRadiusPercent,
            options: [.drawsAfterEndLocation, .drawsBeforeStartLocation]
        )
    }
}
