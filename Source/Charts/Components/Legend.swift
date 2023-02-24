//
//  Legend.swift
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

@objc(ChartLegend)
open class Legend: ComponentBase
{
    @objc(ChartLegendForm)
    public enum Form: Int
    {
        /// Avoid drawing a form 避免绘制表单
        case none
        
        /// Do not draw the a form, but leave space for it
        /// 不要绘制表单，但要为其留出空间
        case empty
        
        /// Use default (default dataset's form to the legend's form)
        /// 使用默认值（默认数据集的形式为图例的形式）
        case `default`
        
        /// Draw a square
        /// 画一个正方形
        case square
        
        /// Draw a circle
        /// 绘制一个圆
        case circle
        
        /// Draw a horizontal line
        /// 绘制水平线
        case line
    }
    
    @objc(ChartLegendHorizontalAlignment)
    public enum HorizontalAlignment: Int
    {
        case left
        case center
        case right
    }
    
    @objc(ChartLegendVerticalAlignment)
    public enum VerticalAlignment: Int
    {
        case top
        case center
        case bottom
    }
    
    @objc(ChartLegendOrientation)
    public enum Orientation: Int
    {
        case horizontal
        case vertical
    }
    
    @objc(ChartLegendDirection)
    public enum Direction: Int
    {
        case leftToRight
        case rightToLeft
    }
    
    /// The legend entries array
    /// 图例条目数组
    @objc open var entries = [LegendEntry]()
    
    /// Entries that will be appended to the end of the auto calculated entries after calculating the legend.
    /// 计算图例后，将附加到自动计算条目末尾的条目。
    /// (if the legend has already been calculated, you will need to call notifyDataSetChanged() to let the changes take effect)
    /// 如果图例已经计算，则需要调用notifyDataSetChanged（）以使更改生效）
    @objc open var extraEntries = [LegendEntry]()
    
    /// Are the legend labels/colors a custom value or auto calculated? If false, then it's auto, if true, then custom.
    /// 图例标签/颜色是自定义值还是自动计算的？如果为假，则为自动，如果为真，则为自定义。
    /// **default**: false (automatic legend)
    private var _isLegendCustom = false

    /// The horizontal alignment of the legend
    /// 图例的水平对齐方式
    @objc open var horizontalAlignment: HorizontalAlignment = HorizontalAlignment.left
    
    /// The vertical alignment of the legend
    /// 图例的垂直对齐方式
    @objc open var verticalAlignment: VerticalAlignment = VerticalAlignment.bottom
    
    /// The orientation of the legend
    /// 图例的方向
    @objc open var orientation: Orientation = Orientation.horizontal
    
    /// Flag indicating whether the legend will draw inside the chart or outside
    /// 指示图例是绘制在图表内部还是外部的标志
    @objc open var drawInside: Bool = false
    
    /// Flag indicating whether the legend will draw inside the chart or outside
    /// 指示图例是绘制在图表内部还是外部的标志
    @objc open var isDrawInsideEnabled: Bool { return drawInside }
    
    /// The text direction of the legend
    /// 图例的文本方向
    @objc open var direction: Direction = Direction.leftToRight

    @objc open var font: NSUIFont = NSUIFont.systemFont(ofSize: 10.0)
    @objc open var textColor = NSUIColor.labelOrBlack

    /// The form/shape of the legend forms
    /// 图例形式/形状
    @objc open var form = Form.square
    
    /// The size of the legend forms
    /// 图例形式的大小
    @objc open var formSize = CGFloat(8.0)
    
    /// The line width for forms that consist of lines
    /// 由线条组成的表单的线宽
    @objc open var formLineWidth = CGFloat(3.0)
    
    /// Line dash configuration for shapes that consist of lines.
    /// 由线组成的形状的虚线配置。
    /// This is how much (in pixels) into the dash pattern are we starting from.
    /// 这是我们从虚线模式开始的数量（以像素为单位）。
    @objc open var formLineDashPhase: CGFloat = 0.0
    
    /// Line dash configuration for shapes that consist of lines.
    /// 由线组成的形状的虚线配置。
    /// This is the actual dash pattern.
    /// 这是实际的虚线图案。
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    @objc open var formLineDashLengths: [CGFloat]?
    
    @objc open var xEntrySpace = CGFloat(6.0)
    @objc open var yEntrySpace = CGFloat(0.0)
    @objc open var formToTextSpace = CGFloat(5.0)
    @objc open var stackSpace = CGFloat(3.0)
    
    @objc open var calculatedLabelSizes = [CGSize]()
    @objc open var calculatedLabelBreakPoints = [Bool]()
    @objc open var calculatedLineSizes = [CGSize]()
    
    public override init()
    {
        super.init()
        
        self.xOffset = 5.0
        self.yOffset = 3.0
    }
    
    @objc public init(entries: [LegendEntry])
    {
        super.init()
        
        self.entries = entries
    }
    
    @objc open func getMaximumEntrySize(withFont font: NSUIFont) -> CGSize
    {
        var maxW = CGFloat(0.0)
        var maxH = CGFloat(0.0)
        
        var maxFormSize: CGFloat = 0.0

        for entry in entries
        {
            let formSize = entry.formSize.isNaN ? self.formSize : entry.formSize
            if formSize > maxFormSize
            {
                maxFormSize = formSize
            }
            
            guard let label = entry.label
                else { continue }
            
            let size = (label as NSString).size(withAttributes: [.font: font])
            
            if size.width > maxW
            {
                maxW = size.width
            }
            if size.height > maxH
            {
                maxH = size.height
            }
        }
        
        return CGSize(
            width: maxW + maxFormSize + formToTextSpace,
            height: maxH
        )
    }

    @objc open var neededWidth = CGFloat(0.0)
    @objc open var neededHeight = CGFloat(0.0)
    @objc open var textWidthMax = CGFloat(0.0)
    @objc open var textHeightMax = CGFloat(0.0)
    
    /// flag that indicates if word wrapping is enabled
    /// this is currently supported only for `orientation == Horizontal`.
    /// you may want to set maxSizePercent when word wrapping, to set the point where the text wraps.
    /// 
    /// **default**: true
    @objc open var wordWrapEnabled = true
    
    /// if this is set, then word wrapping the legend is enabled.
    @objc open var isWordWrapEnabled: Bool { return wordWrapEnabled }

    /// The maximum relative size out of the whole chart view in percent.
    /// If the legend is to the right/left of the chart, then this affects the width of the legend.
    /// If the legend is to the top/bottom of the chart, then this affects the height of the legend.
    /// 
    /// **default**: 0.95 (95%)
    @objc open var maxSizePercent: CGFloat = 0.95
    
    /// 计算尺寸
    @objc open func calculateDimensions(labelFont: NSUIFont, viewPortHandler: ViewPortHandler)
    {
        let maxEntrySize = getMaximumEntrySize(withFont: labelFont)
        let defaultFormSize = self.formSize
        let stackSpace = self.stackSpace
        let formToTextSpace = self.formToTextSpace
        let xEntrySpace = self.xEntrySpace
        let yEntrySpace = self.yEntrySpace
        let wordWrapEnabled = self.wordWrapEnabled
        let entries = self.entries
        let entryCount = entries.count
        
        textWidthMax = maxEntrySize.width
        textHeightMax = maxEntrySize.height
        
        switch orientation
        {
        case .vertical:
            
            var maxWidth = CGFloat(0.0)
            var width = CGFloat(0.0)
            var maxHeight = CGFloat(0.0)
            let labelLineHeight = labelFont.lineHeight
            
            var wasStacked = false
            
            for i in 0 ..< entryCount
            {
                let e = entries[i]
                let drawingForm = e.form != .none
                let formSize = e.formSize.isNaN ? defaultFormSize : e.formSize
                let label = e.label
                
                if !wasStacked
                {
                    width = 0.0
                }
                
                if drawingForm
                {
                    if wasStacked
                    {
                        width += stackSpace
                    }
                    width += formSize
                }
                
                if label != nil
                {
                    let size = (label! as NSString).size(withAttributes: [.font: labelFont])
                    
                    if drawingForm && !wasStacked
                    {
                        width += formToTextSpace
                    }
                    else if wasStacked
                    {
                        maxWidth = max(maxWidth, width)
                        maxHeight += labelLineHeight + yEntrySpace
                        width = 0.0
                        wasStacked = false
                    }
                    
                    width += size.width
                    maxHeight += labelLineHeight + yEntrySpace
                }
                else
                {
                    wasStacked = true
                    width += formSize
                    
                    if i < entryCount - 1
                    {
                        width += stackSpace
                    }
                }
                
                maxWidth = max(maxWidth, width)
            }
            
            neededWidth = maxWidth
            neededHeight = maxHeight
            
        case .horizontal:
            
            let labelLineHeight = labelFont.lineHeight
            
            let contentWidth: CGFloat = viewPortHandler.contentWidth * maxSizePercent
            
            // Prepare arrays for calculated layout
            if calculatedLabelSizes.count != entryCount
            {
                calculatedLabelSizes = [CGSize](repeating: CGSize(), count: entryCount)
            }
            
            if calculatedLabelBreakPoints.count != entryCount
            {
                calculatedLabelBreakPoints = [Bool](repeating: false, count: entryCount)
            }
            
            calculatedLineSizes.removeAll(keepingCapacity: true)
            
            // Start calculating layout
            
            let labelAttrs = [NSAttributedString.Key.font: labelFont]
            var maxLineWidth: CGFloat = 0.0
            var currentLineWidth: CGFloat = 0.0
            var requiredWidth: CGFloat = 0.0
            var stackedStartIndex: Int = -1
            
            for i in 0 ..< entryCount
            {
                let e = entries[i]
                let drawingForm = e.form != .none
                let label = e.label
                
                calculatedLabelBreakPoints[i] = false
                
                if stackedStartIndex == -1
                {
                    // we are not stacking, so required width is for this label only
                    requiredWidth = 0.0
                }
                else
                {
                    // add the spacing appropriate for stacked labels/forms
                    requiredWidth += stackSpace
                }
                
                // grouped forms have null labels
                if label != nil
                {
                    calculatedLabelSizes[i] = (label! as NSString).size(withAttributes: labelAttrs)
                    requiredWidth += drawingForm ? formToTextSpace + formSize : 0.0
                    requiredWidth += calculatedLabelSizes[i].width
                }
                else
                {
                    calculatedLabelSizes[i] = CGSize()
                    requiredWidth += drawingForm ? formSize : 0.0
                    
                    if stackedStartIndex == -1
                    {
                        // mark this index as we might want to break here later
                        stackedStartIndex = i
                    }
                }
                
                if label != nil || i == entryCount - 1
                {
                    let requiredSpacing = currentLineWidth == 0.0 ? 0.0 : xEntrySpace
                    
                    if (!wordWrapEnabled || // No word wrapping, it must fit.
                        currentLineWidth == 0.0 || // The line is empty, it must fit.
                        (contentWidth - currentLineWidth >= requiredSpacing + requiredWidth)) // It simply fits
                    {
                        // Expand current line
                        currentLineWidth += requiredSpacing + requiredWidth
                    }
                    else
                    { // It doesn't fit, we need to wrap a line
                        
                        // Add current line size to array
                        calculatedLineSizes.append(CGSize(width: currentLineWidth, height: labelLineHeight))
                        maxLineWidth = max(maxLineWidth, currentLineWidth)
                        
                        // Start a new line
                        calculatedLabelBreakPoints[stackedStartIndex > -1 ? stackedStartIndex : i] = true
                        currentLineWidth = requiredWidth
                    }
                    
                    if i == entryCount - 1
                    { // Add last line size to array
                        calculatedLineSizes.append(CGSize(width: currentLineWidth, height: labelLineHeight))
                        maxLineWidth = max(maxLineWidth, currentLineWidth)
                    }
                }
                
                stackedStartIndex = label != nil ? -1 : stackedStartIndex
            }
            
            neededWidth = maxLineWidth
            neededHeight = labelLineHeight * CGFloat(calculatedLineSizes.count) +
                yEntrySpace * CGFloat(calculatedLineSizes.count == 0 ? 0 : (calculatedLineSizes.count - 1))
        }
        
        neededWidth += xOffset
        neededHeight += yOffset
    }
    
    /// MARK: - Custom legend
    
    /// Sets a custom legend's entries array.
    /// * A nil label will start a group.
    /// This will disable the feature that automatically calculates the legend entries from the datasets.
    /// Call `resetCustom(...)` to re-enable automatic calculation (and then `notifyDataSetChanged()` is needed).
    @objc open func setCustom(entries: [LegendEntry])
    {
        self.entries = entries
        _isLegendCustom = true
    }
    
    /// Calling this will disable the custom legend entries (set by `setLegend(...)`). Instead, the entries will again be calculated automatically (after `notifyDataSetChanged()` is called).
    @objc open func resetCustom()
    {
        _isLegendCustom = false
    }
    
    /// **default**: false (automatic legend)
    /// `true` if a custom legend entries has been set
    /// `true`如果已设置自定义图例项
    @objc open var isLegendCustom: Bool
    {
        return _isLegendCustom
    }
}
