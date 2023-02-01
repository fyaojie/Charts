//
//  Utils.swift
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

extension Comparable
{
    /// 根据当前值和范围获取对应值, 超过上限取上限, 超过下限取下限
    func clamped(to range: ClosedRange<Self>) -> Self
    {
        if self > range.upperBound
        {
            return range.upperBound
        }
        else if self < range.lowerBound
        {
            return range.lowerBound
        }
        else
        {
            return self
        }
    }
}

extension FloatingPoint
{
    /// 角度转弧度
    var DEG2RAD: Self
    {
        return self * .pi / 180
    }

    /// 弧度转角度
    var RAD2DEG: Self
    {
        return self * 180 / .pi
    }

    /// - Note: Value must be in degrees 值必须以度为单位
    /// - Returns: An angle between 0.0 < 360.0 (not less than zero, less than 360) 0.0<360.0之间的角度（不小于零，小于360）
    var normalizedAngle: Self
    {
        let angle = truncatingRemainder(dividingBy: 360)
        return (sign == .minus) ? angle + 360 : angle
    }
}

extension CGSize
{
    func rotatedBy(degrees: CGFloat) -> CGSize
    {
        let radians = degrees.DEG2RAD
        return rotatedBy(radians: radians)
    }

    func rotatedBy(radians: CGFloat) -> CGSize
    {
        return CGSize(
            width: abs(width * cos(radians)) + abs(height * sin(radians)),
            height: abs(width * sin(radians)) + abs(height * cos(radians))
        )
    }
}

extension Double
{
    /// Rounds the number to the nearest multiple of it's order of magnitude, rounding away from zero if halfway.
    /// 将数字舍入到其数量级的最接近倍数，如果中途舍入，则从零开始舍入
    func roundedToNextSignificant() -> Double
    {
        guard
            !isInfinite, /// 检查当前的浮点数值是否为无限数值
            !isNaN,  /// 检查当前数字是否为非数字
            self != 0
            else { return self }

        /// 向上取整获取倍数
        let d = ceil(log10(self < 0 ? -self : self))
        let pw = 1 - Int(d)
        let magnitude = pow(10.0, Double(pw))
        let shifted = (self * magnitude).rounded()
        return shifted / magnitude
    }

    /// 小数点位数
    var decimalPlaces: Int
    {
        guard
            !isNaN,
            !isInfinite,
            self != 0.0
            else { return 0 }

        let i = roundedToNextSignificant()

        guard
            !i.isInfinite,
            !i.isNaN
            else { return 0 }

        return Int(ceil(-log10(i))) + 2
    }
}

extension CGPoint
{
    /// Calculates the position around a center point, depending on the distance from the center, and the angle of the position around the center.
    /// 根据距中心的距离和围绕中心的位置的角度，计算围绕中心点的位置。
    func moving(distance: CGFloat, atAngle angle: CGFloat) -> CGPoint
    {
        return CGPoint(x: x + distance * cos(angle.DEG2RAD),
                       y: y + distance * sin(angle.DEG2RAD))
    }
}

extension CGContext
{

    public func drawImage(_ image: NSUIImage, atCenter center: CGPoint, size: CGSize)
    {
        var drawOffset = CGPoint()
        drawOffset.x = center.x - (size.width / 2)
        drawOffset.y = center.y - (size.height / 2)

        NSUIGraphicsPushContext(self)

        if image.size.width != size.width && image.size.height != size.height
        {
            let key = "resized_\(size.width)_\(size.height)"

            /// Try to take scaled image from cache of this image
            /// 尝试从此图像的缓存中获取缩放图像
            var scaledImage = objc_getAssociatedObject(image, key) as? NSUIImage
            if scaledImage == nil
            {
                // Scale the image 缩放图像
                NSUIGraphicsBeginImageContextWithOptions(size, false, 0.0)

                image.draw(in: CGRect(origin: .zero, size: size))

                scaledImage = NSUIGraphicsGetImageFromCurrentImageContext()
                NSUIGraphicsEndImageContext()

                /// Put the scaled image in a cache owned by the original image
                /// 将缩放图像放在原始图像拥有的缓存中
                objc_setAssociatedObject(image, key, scaledImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }

            scaledImage?.draw(in: CGRect(origin: drawOffset, size: size))
        }
        else
        {
            image.draw(in: CGRect(origin: drawOffset, size: size))
        }

        NSUIGraphicsPopContext()
    }

    public func drawText(_ text: String, at point: CGPoint, align: TextAlignment, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5), angleRadians: CGFloat = 0.0, attributes: [NSAttributedString.Key : Any]?)
    {
        let drawPoint = getDrawPoint(text: text, point: point, align: align, attributes: attributes)
        
        if (angleRadians == 0.0)
        {
            NSUIGraphicsPushContext(self)
            
            (text as NSString).draw(at: drawPoint, withAttributes: attributes)
            
            NSUIGraphicsPopContext()
        }
        else
        {
            drawText(text, at: drawPoint, anchor: anchor, angleRadians: angleRadians, attributes: attributes)
        }
    }
    
    public func drawText(_ text: String, at point: CGPoint, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5), angleRadians: CGFloat, attributes: [NSAttributedString.Key : Any]?)
    {
        var drawOffset = CGPoint()

        NSUIGraphicsPushContext(self)

        if angleRadians != 0.0
        {
            let size = text.size(withAttributes: attributes)

            // Move the text drawing rect in a way that it always rotates around its center
            drawOffset.x = -size.width * 0.5
            drawOffset.y = -size.height * 0.5

            var translate = point

            // Move the "outer" rect relative to the anchor, assuming its centered
            if anchor.x != 0.5 || anchor.y != 0.5
            {
                let rotatedSize = size.rotatedBy(radians: angleRadians)

                translate.x -= rotatedSize.width * (anchor.x - 0.5)
                translate.y -= rotatedSize.height * (anchor.y - 0.5)
            }

            saveGState()
            translateBy(x: translate.x, y: translate.y)
            rotate(by: angleRadians)

            (text as NSString).draw(at: drawOffset, withAttributes: attributes)

            restoreGState()
        }
        else
        {
            if anchor.x != 0.0 || anchor.y != 0.0
            {
                let size = text.size(withAttributes: attributes)

                drawOffset.x = -size.width * anchor.x
                drawOffset.y = -size.height * anchor.y
            }

            drawOffset.x += point.x
            drawOffset.y += point.y

            (text as NSString).draw(at: drawOffset, withAttributes: attributes)
        }

        NSUIGraphicsPopContext()
    }

    private func getDrawPoint(text: String, point: CGPoint, align: TextAlignment, attributes: [NSAttributedString.Key : Any]?) -> CGPoint
    {
        var point = point
        
        if align == .center
        {
            point.x -= text.size(withAttributes: attributes).width / 2.0
        }
        else if align == .right
        {
            point.x -= text.size(withAttributes: attributes).width
        }
        return point
    }
    
    func drawMultilineText(_ text: String, at point: CGPoint, constrainedTo size: CGSize, anchor: CGPoint, knownTextSize: CGSize, angleRadians: CGFloat, attributes: [NSAttributedString.Key : Any]?)
    {
        var rect = CGRect(origin: .zero, size: knownTextSize)

        NSUIGraphicsPushContext(self)

        if angleRadians != 0.0
        {
            // Move the text drawing rect in a way that it always rotates around its center
            rect.origin.x = -knownTextSize.width * 0.5
            rect.origin.y = -knownTextSize.height * 0.5

            var translate = point

            // Move the "outer" rect relative to the anchor, assuming its centered
            if anchor.x != 0.5 || anchor.y != 0.5
            {
                let rotatedSize = knownTextSize.rotatedBy(radians: angleRadians)

                translate.x -= rotatedSize.width * (anchor.x - 0.5)
                translate.y -= rotatedSize.height * (anchor.y - 0.5)
            }

            saveGState()
            translateBy(x: translate.x, y: translate.y)
            rotate(by: angleRadians)

            (text as NSString).draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

            restoreGState()
        }
        else
        {
            if anchor.x != 0.0 || anchor.y != 0.0
            {
                rect.origin.x = -knownTextSize.width * anchor.x
                rect.origin.y = -knownTextSize.height * anchor.y
            }

            rect.origin.x += point.x
            rect.origin.y += point.y

            (text as NSString).draw(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        }

        NSUIGraphicsPopContext()
    }

    func drawMultilineText(_ text: String, at point: CGPoint, constrainedTo size: CGSize, anchor: CGPoint, angleRadians: CGFloat, attributes: [NSAttributedString.Key : Any]?)
    {
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        drawMultilineText(text, at: point, constrainedTo: size, anchor: anchor, knownTextSize: rect.size, angleRadians: angleRadians, attributes: attributes)
    }
}
