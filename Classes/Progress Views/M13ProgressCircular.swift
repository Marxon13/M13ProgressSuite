//
//  M13ProgressCircular.swift
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
The possible directions a circular progress indicator can travel in.

- Clockwise: The progress ring will travel clockwise as the progress nears completion.
- CounterClockwise: The progress ring will travel counter-clockwise as the progress nears completion.
*/
public enum M13ProgressCircularProgressDirection: Int, RawRepresentable {
    /// The progress ring will travel clockwise as the progress nears completion.
    case Clockwise
    /// The progress ring will travel counter-clockwise as the progress nears completion.
    case CounterClockwise
}

/**
Base class for circular progress views.
Ring and Pie progress views are derived from this class. Do not instantiate directly.
*/
@IBDesignable
public class M13ProgressCircular: M13ProgressView {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The direction the progress bar travels in as the progress nears completion.
    */
    @IBInspectable public var progressDirection: M13ProgressCircularProgressDirection = .Clockwise {
        didSet {
            progressUpdate?()
        }
    }
    
    @IBInspectable public var backgroundRingWidth :Int = 0 {
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
    
    //-------------------------------
    // MARK: Layers
    //-------------------------------
    
    /**
    The layer that makes up the progress ring.
    */
    internal var progressLayer: CAShapeLayer = CAShapeLayer()
    
    /**
    The layer that makes up the indeterminate ring, and the background for the progress ring.
    */
    internal var indeterminateLayer: CAShapeLayer = CAShapeLayer()
    
    /**
    The layer that is used to render icons for success or failure.
    */
    internal var iconLayer: CAShapeLayer = CAShapeLayer()
    
    //-------------------------------
    // MARK: Protected Variables
    //-------------------------------
    
    /** The starting angle for drawing the indeterminate animation ring. */
    internal var indeterminateAnimationAngle :CGFloat = 0
    /** Ring widths after validation and bounds adjustments */
    internal var adjustedBackgroundRingWidth :CGFloat = 0
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValueForKey("progressDirection") {
            if let direction = M13ProgressCircularProgressDirection(rawValue: aDecoder.decodeIntegerForKey("progressDirection")) {
                progressDirection = direction
            }
        }
        if aDecoder.containsValueForKey("backgroundRingWidth") {
            backgroundRingWidth = aDecoder.decodeIntegerForKey("backgroundRingWidth")
        }
        
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    internal func sharedSetup() {
        // Set the defaults.
        self.clipsToBounds = false
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        // Set up the indeterminate layer
        indeterminateLayer = CAShapeLayer()
        indeterminateLayer.backgroundColor = UIColor.clearColor().CGColor
        indeterminateLayer.strokeColor = secondaryColor.CGColor
        indeterminateLayer.fillColor = nil
        indeterminateLayer.lineCap = kCALineCapRound
        
        // Set up the progress layer
        progressLayer = CAShapeLayer()
        progressLayer.backgroundColor = UIColor.clearColor().CGColor
        progressLayer.strokeColor = nil
        progressLayer.fillColor = tintColor.CGColor
        progressLayer.lineCap = kCALineCapButt
        
        adjustBackgroundRingWidth()
        
        // Set up the icon layer
        iconLayer = CAShapeLayer()
        iconLayer.backgroundColor = UIColor.clearColor().CGColor
        iconLayer.strokeColor = nil
        iconLayer.fillColor = nil
        iconLayer.lineCap = kCALineCapButt
        
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
        layer.addSublayer(progressLayer)
        layer.addSublayer(iconLayer)
        
        // Be sure to implement progressUpdate() and indeterminateUpdate in child classes.
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(progressDirection.rawValue, forKey: "progressDirection")
        aCoder.encodeInteger(backgroundRingWidth, forKey: "backgroundRingWidth")
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
        
        switch state {
        case .Normal:
            hideIcon()
            break
        case .Success:
            drawSuccess()
            break
        case .Failure:
            drawFailure()
            break
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
        
        adjustBackgroundRingWidth()
        
        // Update progress frame
        progressUpdate?()
    }
    
    public func adjustBackgroundRingWidth()
    {
        if backgroundRingWidth > 0 {
            adjustedBackgroundRingWidth = CGFloat(backgroundRingWidth)
        } else {
            adjustedBackgroundRingWidth = max(self.bounds.size.width * 0.025, 1.0)
        }
        indeterminateLayer.lineWidth = adjustedBackgroundRingWidth
    }
    
    //-------------------------------
    // MARK: Draw Functions
    //-------------------------------
    
    public func maxRadius() -> CGFloat
    {
        return min(self.bounds.size.width, self.bounds.size.height) / 2.0
    }
    
    public func centerOfCircle() -> CGPoint
    {
        return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
    }
    
    public func createPieSlicePath(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(center)
        path.addLineToPoint(CGPointMake(center.x + radius * cos(startAngle), center.y + radius * sin(startAngle)))
        path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path.closePath()
        return path
    }
    
    public func drawBackground()
    {
        // Draw a circle
        let center = centerOfCircle()
        let radius = maxRadius() - adjustedBackgroundRingWidth / 2.0
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: radius, startAngle: 0, endAngle: 2.0 * CGFloat(M_PI), clockwise: true)
        indeterminateLayer.path = path.CGPath
    }
    
    public func drawSuccess()
    {
        // Draw relative to a base size and percentage, that way the check can be drawn for any size.
        let radius = maxRadius()
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
    
    public func drawFailure()
    {
        // Calculate the size of the X
        let radius = maxRadius()
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
    
    public func hideIcon()
    {
        iconLayer.path = nil
    }
    
    //-------------------------------
    // MARK: Other
    //-------------------------------
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        progressLayer.fillColor = tintColor.CGColor
        progressLayer.strokeColor = nil
    }
    
}
