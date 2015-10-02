//
//  M13ProgressRing.swift
//  M13ProgressSuite
//
/*
Copyright (c) 2015 Brandon McQuilkin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import UIKit

/**
The possible directions a progress ring can travel in.

- Clockwise: The progress ring will travel clockwise as the progress nears completion.
- CounterClockwise: The progress ring will travel counter-clockwise as the progress nears completion.
*/
public enum M13ProgressRingProgressDirection: Int, RawRepresentable {
    /// The progress ring will travel clockwise as the progress nears completion.
    case Clockwise
    /// The progress ring will travel counter-clockwise as the progress nears completion.
    case CounterClockwise
}

/**
A progress view stylized similarly to the iOS 7 App store progress view.
*/
@IBDesignable
public class M13ProgressRing: M13ProgressView {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The direction the progress bar travels in as the progress nears completion.
    */
    @IBInspectable public var progressDirection: M13ProgressRingProgressDirection = .Clockwise {
        didSet {
            progressUpdate?()
        }
    }
    
    @IBInspectable public var percentage: Bool = false {
        didSet {
            // Show the label if not already.
            if percentage && percentageLabel.superview == nil {
                addSubview(percentageLabel)
            }
            
            // Hide the label if not already
            if !percentage && percentageLabel.superview != nil {
                percentageLabel.removeFromSuperview()
            }
            
            setNeedsLayout()
            progressUpdate?()
        }
    }
    
    @IBInspectable public var backgroundRingWidth :Int = 0 {
        didSet {
            setNeedsLayout()
            progressUpdate?()
        }
    }
    
    @IBInspectable public var progressRingWidth :Int = 0 {
        didSet {
            setNeedsLayout()
            progressUpdate?()
        }
    }

    //-------------------------------
    // MARK: Property Overrides
    //-------------------------------
    
    /**
    The secondary color of the progress view.
    */
    override public var secondaryColor: UIColor {
        didSet {
            indeterminateLayer.strokeColor = secondaryColor.CGColor
        }
    }
    
    /**
    The primary color when the progress view is in the success state.
    */
    override public var successColor: UIColor {
        didSet {
            if state == .Success {
                iconLayer.fillColor = successColor.CGColor
            }
        }
    }
    
    /**
    The primary color when the progress view is in the failure state.
    */
    override public var failureColor: UIColor {
        didSet {
            if state == .Failure {
                iconLayer.fillColor = failureColor.CGColor
            }
        }
    }
    
    override public var indeterminate: Bool {
        didSet {
            // Add the indeterminate layer.
            if indeterminate {
                hidePercentage()
                progressLayer.removeFromSuperlayer()
                if indeterminateLayer.superlayer == nil {
                    layer.addSublayer(indeterminateLayer)
                }
            }
            
            // Add the progress layer.
            if !indeterminate && progressLayer.superlayer == nil {
                layer.addSublayer(progressLayer)
            }
        }
    }
    
    //-------------------------------
    // MARK: Layers
    //-------------------------------
    
    /**
    The layer that makes up the progress ring.
    */
    private var progressLayer: CAShapeLayer = CAShapeLayer()
    
    /**
    The layer that makes up the indeterminate ring, and the background for the progress ring.
    */
    private var indeterminateLayer: CAShapeLayer = CAShapeLayer()
    
    /**
    The layer that is used to render icons for success or failure.
    */
    private var iconLayer: CAShapeLayer = CAShapeLayer()
    
    //-------------------------------
    // MARK: Private Variables
    //-------------------------------
    
    /** The number formatter to display the progress percentage. */
    private var percentageFormatter: NSNumberFormatter!
    /** The label that shows the percentage. */
    private var percentageLabel: UILabel!
    /** The starting angle for drawing the indeterminate animation ring. */
    private var indeterminateAnimationAngle :CGFloat = 0
    /** Ring widths after validation and bounds adjustments */
    private var adjustedBackgroundRingWidth :CGFloat = 0
    private var adjustedProgressRingWidth :CGFloat = 0

    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValueForKey("progressDirection") {
            if let direction = M13ProgressRingProgressDirection(rawValue: aDecoder.decodeIntegerForKey("progressDirection")) {
                progressDirection = direction
            }
        }
        if aDecoder.containsValueForKey("percentage") {
            percentage = aDecoder.decodeBoolForKey("percentage")
        }
        if aDecoder.containsValueForKey("backgroundRingWidth") {
            backgroundRingWidth = aDecoder.decodeIntegerForKey("backgroundRingWidth")
        }
        if aDecoder.containsValueForKey("progressRingWidth") {
            progressRingWidth = aDecoder.decodeIntegerForKey("progressRingWidth")
        }
        
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    private func sharedSetup() {
        // Set the defaults.
        self.clipsToBounds = false
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        // Set up the number formatter
        percentageFormatter = NSNumberFormatter()
        percentageFormatter.numberStyle = .PercentStyle
                
        // Set up the indeterminate layer
        indeterminateLayer = CAShapeLayer()
        indeterminateLayer.backgroundColor = UIColor.clearColor().CGColor
        indeterminateLayer.strokeColor = secondaryColor.CGColor
        indeterminateLayer.fillColor = nil
        indeterminateLayer.lineCap = kCALineCapRound
        
        // Set up the progress layer
        progressLayer = CAShapeLayer()
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.strokeColor = tintColor.CGColor
        progressLayer.fillColor = nil
        progressLayer.lineCap = kCALineCapButt

        adjustRingWidths()
        
        // Set up the icon layer
        iconLayer = CAShapeLayer()
        iconLayer.backgroundColor = UIColor.clearColor().CGColor
        iconLayer.strokeColor = nil
        iconLayer.fillColor = nil
        iconLayer.lineCap = kCALineCapButt
        
        // Set the percentage label
        percentageLabel = UILabel(frame: self.bounds)
        percentageLabel.textAlignment = .Center
        percentageLabel.contentMode = .Center
        self.addSubview(percentageLabel)
        
        // Disable default animations
        progressLayer.actions = [
            "frame": NSNull(),
            "anchorPoint": NSNull(),
            "bounds": NSNull(),
            "position": NSNull(),
        ]
        indeterminateLayer.actions = [
            "frame": NSNull(),
            "anchorPoint": NSNull(),
            "bounds": NSNull(),
            "position": NSNull(),
        ]
        iconLayer.actions = [
            "frame": NSNull(),
            "anchorPoint": NSNull(),
            "bounds": NSNull(),
            "position": NSNull(),
        ]
        
        // Add the layers
        layer.addSublayer(indeterminateLayer)
        if !indeterminate {
            layer.addSublayer(progressLayer)
        }
        layer.addSublayer(iconLayer)
        
        // Set the progress animation.
        weak var weakSelf: M13ProgressRing? = self
        progressUpdate = {() -> Void in
            
            if let retainedSelf = weakSelf {
                
                // Create parameters to draw ring
                let minSize = min(retainedSelf.bounds.size.width, retainedSelf.bounds.size.height)
                let clockwise = (retainedSelf.progressDirection == .Clockwise)
                let center = CGPointMake(self.bounds.size.width / 2.0, retainedSelf.bounds.size.height / 2.0)
                var startAngle = CGFloat(-M_PI_2)
                var endAngle = startAngle + (2.0 * CGFloat(M_PI) * retainedSelf.progress)
                if !clockwise {
                    // For counter-clockwise, subtract angles from 360 degrees, and swap start-end
                    let tmp = CGFloat(M_PI) - startAngle
                    startAngle = CGFloat(M_PI) - endAngle
                    endAngle = tmp
                }
                
                // Draw background
                let radius1 = (minSize - retainedSelf.adjustedBackgroundRingWidth) / 2.0
                let path1 = UIBezierPath()
                path1.addArcWithCenter(center, radius: radius1, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
                retainedSelf.indeterminateLayer.path = path1.CGPath

                // Draw progress ring
                let radius2 = (minSize - retainedSelf.adjustedProgressRingWidth) / 2.0
                let path2 = UIBezierPath()
                path2.addArcWithCenter(center, radius: radius2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                retainedSelf.progressLayer.path = path2.CGPath
                
                // Draw percentage
                if retainedSelf.percentage && retainedSelf.state == .Normal {
                    retainedSelf.drawPercentage()
                }
            }
        }
        
        // Set the indeterminate animation.
        indeterminateUpdate = {(frameDuration: CFTimeInterval) -> Void in
            
            if let retainedSelf = weakSelf {
                
                retainedSelf.hidePercentage()

                // Create parameters to draw progress
                let startAngle = CGFloat(retainedSelf.indeterminateAnimationAngle)
                let endAngle = startAngle + CGFloat(M_PI) * 2.0 * 0.8  // 80% of a circle
                let center = CGPointMake(self.bounds.size.width / 2.0, retainedSelf.bounds.size.width / 2.0)
                let radius = (retainedSelf.bounds.size.width - retainedSelf.adjustedBackgroundRingWidth) / 2.0
                
                let deltaAngle = CGFloat(frameDuration * 2.0 * M_PI)
                if retainedSelf.progressDirection == .CounterClockwise {
                    // CounterClockwise
                    retainedSelf.indeterminateAnimationAngle -= deltaAngle
                } else {
                    // Clockwise
                    retainedSelf.indeterminateAnimationAngle += deltaAngle
                }
                
                // Draw path
                let path = UIBezierPath()
                path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                
                // Set the path
                retainedSelf.indeterminateLayer.path = path.CGPath
            }
        }
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(progressDirection.rawValue, forKey: "progressDirection")
        aCoder.encodeBool(percentage, forKey: "percentage")
        aCoder.encodeInteger(backgroundRingWidth, forKey: "backgroundRingWidth")
        aCoder.encodeInteger(progressRingWidth, forKey: "progressRingWidth")
        super.encodeWithCoder(aCoder)
    }
    
    public override func prepareForInterfaceBuilder() {
        sharedSetup()
        super.prepareForInterfaceBuilder()
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------
    
    public override func setState(state: M13ProgressViewState, animated: Bool) {
        super.setState(state, animated: animated)
        
        var toColor1: UIColor = tintColor
        var toColor2: UIColor = secondaryColor
        switch state {
        case .Normal:
            hideIcon()
            if percentage {
                drawPercentage()
            }
            break
        case .Success:
            hidePercentage()
            drawSuccess()
            toColor1 = successColor
            if (indeterminate) {
                toColor2 = successColor
            }
            break
        case .Failure:
            hidePercentage()
            drawFailure()
            toColor1 = failureColor
            if (indeterminate) {
                toColor2 = failureColor
            }
            break
        }
        
        if !animated {
            progressLayer.backgroundColor = toColor1.CGColor
            indeterminateLayer.strokeColor = toColor2.CGColor
        } else {
            let colorAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
            colorAnimation1.fromValue = progressLayer.backgroundColor!
            colorAnimation1.fillMode = kCAFillModeForwards
            colorAnimation1.removedOnCompletion = false
            colorAnimation1.duration = animationDuration
            
            let colorAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
            colorAnimation2.fromValue = indeterminateLayer.backgroundColor!
            colorAnimation2.fillMode = kCAFillModeForwards
            colorAnimation2.removedOnCompletion = false
            colorAnimation2.duration = animationDuration
            
            colorAnimation1.toValue = toColor1.CGColor
            progressLayer.addAnimation(colorAnimation1, forKey: "strokeColor")
            progressLayer.strokeColor = toColor1.CGColor

            colorAnimation2.toValue = toColor2.CGColor
            indeterminateLayer.addAnimation(colorAnimation2, forKey: "strokeColor")
            indeterminateLayer.strokeColor = toColor2.CGColor
        }
        
        setNeedsLayout()
        progressUpdate?()
    }
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustRingWidths()

        // Percentage label
        if percentage {
            percentageLabel.frame = self.bounds
            percentageLabel.font = UIFont.systemFontOfSize(self.bounds.size.width / 5)
            percentageLabel.textColor = tintColor
        }
        
        // Update progress frame
        progressUpdate?()
    }
    
    public func adjustRingWidths()
    {
        if backgroundRingWidth > 0 {
            adjustedBackgroundRingWidth = CGFloat(backgroundRingWidth)
        } else {
            adjustedBackgroundRingWidth = max(self.bounds.size.width * 0.025, 1.0)
        }
        indeterminateLayer.lineWidth = adjustedBackgroundRingWidth
        
        if progressRingWidth > 0 {
            adjustedProgressRingWidth = CGFloat(progressRingWidth)
        } else {
            adjustedProgressRingWidth = adjustedBackgroundRingWidth * 3.0
        }
        progressLayer.lineWidth = adjustedProgressRingWidth
    }
    
    //-------------------------------
    // MARK: Icons
    //-------------------------------
    
    private func drawSuccess()
    {
        // Draw relative to a base size and percentage, that way the check can be drawn for any size.
        let radius = self.frame.size.width / 2.0
        let size = radius * 0.3
        
        // Create the path for the Checkmark
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(0, size * 2))
        path.addLineToPoint(CGPointMake(size * 3, size * 2))
        path.addLineToPoint(CGPointMake(size * 3, size))
        path.addLineToPoint(CGPointMake(size, size))
        path.addLineToPoint(CGPointMake(size, 0))
        path.closePath()
        
        // Rotate it through -45 degrees...
        path.applyTransform(CGAffineTransformMakeRotation(CGFloat(-M_PI_4)))
        
        // Center it
        path.applyTransform(CGAffineTransformMakeTranslation(radius * 0.46, radius * 1.02))
        
        // Set path and fill color
        iconLayer.path = path.CGPath
        iconLayer.fillColor = successColor.CGColor
    }
    
    private func drawFailure()
    {
        // Calculate the size of the X
        let radius = self.frame.size.width / 2.0
        let size = radius * 0.3
        
        // Create the path for the X
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(size, 0))
        path.addLineToPoint(CGPointMake(2 * size, 0))
        path.addLineToPoint(CGPointMake(2 * size, size))
        path.addLineToPoint(CGPointMake(3 * size, size))
        path.addLineToPoint(CGPointMake(3 * size, 2 * size))
        path.addLineToPoint(CGPointMake(2 * size, 2 * size))
        path.addLineToPoint(CGPointMake(2 * size, 3 * size))
        path.addLineToPoint(CGPointMake(size, 3 * size))
        path.addLineToPoint(CGPointMake(size, 2 * size))
        path.addLineToPoint(CGPointMake(0, 2 * size))
        path.addLineToPoint(CGPointMake(0, size))
        path.addLineToPoint(CGPointMake(size, size))
        path.closePath()
        
        // Center it
        path.applyTransform(CGAffineTransformMakeTranslation(radius - (1.5 * size), radius - (1.5 * size)))
        
        // Rotate path
        let a = CGFloat(cos(M_PI_4))
        let b = CGFloat(sin(M_PI_4))
        let c = CGFloat(-sin(M_PI_4))
        let d = CGFloat(cos(M_PI_4))
        let tx = radius * CGFloat(1 - cos(M_PI_4) + sin(M_PI_4))
        let ty = radius * CGFloat(1 - sin(M_PI_4) - cos(M_PI_4))
        path.applyTransform(CGAffineTransformMake(a, b, c, d, tx, ty))
        
        // Set path and fill color
        iconLayer.path = path.CGPath
        iconLayer.fillColor = failureColor.CGColor
    }
    
    private func hideIcon()
    {
        iconLayer.path = nil
    }
    
    private func drawPercentage()
    {
        percentageLabel.text = percentageFormatter.stringFromNumber(self.progress)
    }
    
    private func hidePercentage()
    {
        percentageLabel.text = ""
    }
    
    //-------------------------------
    // MARK: Other
    //-------------------------------
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        progressLayer.strokeColor = tintColor.CGColor
        percentageLabel.textColor = tintColor
    }
    
}
