//
//  LegendEntry.swift
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

@objc(ChartLegendEntry)
open class LegendEntry: NSObject
{
    public override init()
    {
        super.init()
    }
    
    /// - Parameters:
    ///   - label:                  The legend entry text.
    ///                                     A `nil` label will start a group.
    ///   - form:                   The form to draw for this entry.
    ///   - formSize:               Set to NaN to use the legend's default.
    ///   - formLineWidth:          Set to NaN to use the legend's default.
    ///   - formLineDashPhase:      Line dash configuration.
    ///   - formLineDashLengths:    Line dash configurationas NaN to use the legend's default.
    ///   - formColor:              The color for drawing the form.
    @objc public init(label: String?,
                form: Legend.Form,
                formSize: CGFloat,
                formLineWidth: CGFloat,
                formLineDashPhase: CGFloat,
                formLineDashLengths: [CGFloat]?,
                formColor: NSUIColor?)
    {
        self.label = label
        self.form = form
        self.formSize = formSize
        self.formLineWidth = formLineWidth
        self.formLineDashPhase = formLineDashPhase
        self.formLineDashLengths = formLineDashLengths
        self.formColor = formColor
    }
    
    /// The legend entry text.
    /// 图例条目文本。
    /// A `nil` label will start a group.
    /// “nil”标签将启动一个组。
    @objc open var label: String?
    
    /// The form to draw for this entry.
    /// 要为此条目绘制的表单。
    /// `None` will avoid drawing a form, and any related space.
    /// 将避免绘制表单和任何相关空间。
    /// `Empty` will avoid drawing a form, but keep its space.
    /// `空`将避免绘制表单，但保留其空间。
    /// `Default` will use the Legend's default.
    /// `默认值”将使用图例的默认值。
    @objc open var form: Legend.Form = .default
    
    /// Form size will be considered except for when .None is used
    /// 将考虑表单大小，除非使用 无设置为NaN以使用图例的默认值
    /// Set as NaN to use the legend's default
    @objc open var formSize: CGFloat = CGFloat.nan
    
    /// Line width used for shapes that consist of lines.
    /// 用于由线条组成的形状的线宽。
    /// Set to NaN to use the legend's default.
    /// 设置为NaN以使用图例的默认值。
    @objc open var formLineWidth: CGFloat = CGFloat.nan
    
    /// Line dash configuration for shapes that consist of lines.
    /// 由线组成的形状的虚线配置。
    /// This is how much (in pixels) into the dash pattern are we starting from.
    /// 这是我们从虚线模式开始的数量（以像素为单位）。
    /// Set to NaN to use the legend's default.
    /// 设置为NaN以使用图例的默认值。
    @objc open var formLineDashPhase: CGFloat = 0.0
    
    /// Line dash configuration for shapes that consist of lines.
    /// 由线组成的形状的虚线配置。
    /// This is the actual dash pattern.
    /// 这是实际的虚线图案。
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    ///
    /// Set to nil to use the legend's default.
    /// 设置为nil以使用图例的默认值。
    @objc open var formLineDashLengths: [CGFloat]?
    
    /// The color for drawing the form
    /// 用于绘制表单的颜色
    @objc open var formColor: NSUIColor?
}
