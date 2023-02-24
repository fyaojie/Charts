//
//  Description.swift
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

@objc(ChartDescription)
open class Description: ComponentBase
{
    public override init()
    {
        #if os(tvOS)
        // 23 is the smallest recommended font size on the TV
        font = .systemFont(ofSize: 23)
        #elseif os(OSX)
        font = .systemFont(ofSize: NSUIFont.systemFontSize)
        #else
        font = .systemFont(ofSize: 8.0)
        #endif
        
        super.init()
    }
    
    /// The text to be shown as the description.
    /// 要显示为描述的文本。
    @objc open var text: String?
    
    /// Custom position for the description text in pixels on the screen.
    /// 屏幕上以像素为单位的描述文本的自定义位置。
    open var position: CGPoint? = nil
    
    /// The text alignment of the description text. Default RIGHT.
    /// 描述文本的文本对齐方式。默认权限。
    @objc open var textAlign: NSTextAlignment = NSTextAlignment.right
    
    /// Font object used for drawing the description text.
    /// 用于绘制描述文本的字体对象。
    @objc open var font: NSUIFont
    
    /// Text color used for drawing the description text
    /// 用于绘制描述文本的文本颜色
    @objc open var textColor = NSUIColor.labelOrBlack
}
