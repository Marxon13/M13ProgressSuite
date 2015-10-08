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
A progress view stylized similarly to the iOS 7 App store progress view.
*/
@IBDesignable
public class M13ProgressRing: M13ProgressCircular {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    @IBInspectable public var percentage: Bool = false {
        didSet {
            percentageLabel.hidden = !percentage
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
    
    override public var indeterminate: Bool {
        didSet {
            let tmp = indeterminate
            super.indeterminate = tmp
            if indeterminate {
                progressLayer.hidden = true
                percentageLabel.hidden = true
            } else {
                progressLayer.hidden = false
                percentageLabel.hidden = !percentage
            }
            
            setNeedsLayout()
            progressUpdate?()
        }
    }
    
    //-------------------------------
    // MARK: Protected Variables
    //-------------------------------
    
    /** The number formatter to display the progress percentage. */
    internal var percentageFormatter: NSNumberFormatter!
    /** The label that shows the percentage. */
    internal var percentageLabel: UILabel!
    /** Ring widths after validation and bounds adjustments */
    internal var adjustedProgressRingWidth :CGFloat = 0

    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValueForKey("percentage") {
            percentage = aDecoder.decodeBoolForKey("percentage")
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
    
    internal override func sharedSetup() {
        super.sharedSetup()
        
        // Set the defaults.
        self.clipsToBounds = false
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        // Set up the indeterminate layer
        indeterminateLayer.strokeColor = secondaryColor.CGColor
        indeterminateLayer.fillColor = nil
        
        // Set up the progress layer
        progressLayer.strokeColor = tintColor.CGColor
        progressLayer.fillColor = nil

        adjustProgressRingWidth()
        
        // Set up the number formatter
        percentageFormatter = NSNumberFormatter()
        percentageFormatter.numberStyle = .PercentStyle
        
        // Set the percentage label
        percentageLabel = UILabel(frame: self.bounds)
        percentageLabel.textAlignment = .Center
        percentageLabel.contentMode = .Center
        self.addSubview(percentageLabel)
        
        // Set the progress animation.
        weak var weakSelf: M13ProgressRing? = self
        progressUpdate = {() -> Void in
            
            if let retainedSelf = weakSelf {
                
                // Create parameters to draw ring
                let clockwise = (retainedSelf.progressDirection == .Clockwise)
                var startAngle = CGFloat(-M_PI_2)
                var endAngle = startAngle + (2.0 * CGFloat(M_PI) * retainedSelf.progress)
                if !clockwise {
                    // For counter-clockwise, subtract angles from 360 degrees, and swap start-end
                    let tmp = CGFloat(M_PI) - startAngle
                    startAngle = CGFloat(M_PI) - endAngle
                    endAngle = tmp
                }
                
                // Draw background
                retainedSelf.drawBackground()

                // Draw progress ring
                let center = retainedSelf.centerOfCircle()
                let radius = retainedSelf.maxRadius() - retainedSelf.adjustedProgressRingWidth / 2.0
                let path = UIBezierPath()
                path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                retainedSelf.progressLayer.path = path.CGPath
                
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
                
                let deltaAngle = CGFloat(frameDuration * 2.0 * M_PI)
                if retainedSelf.progressDirection == .CounterClockwise {
                    // CounterClockwise
                    retainedSelf.indeterminateAnimationAngle -= deltaAngle
                } else {
                    // Clockwise
                    retainedSelf.indeterminateAnimationAngle += deltaAngle
                }
                
                // Draw path
                let center = retainedSelf.centerOfCircle()
                let radius = retainedSelf.maxRadius() - retainedSelf.adjustedBackgroundRingWidth / 2.0
                let path = UIBezierPath()
                path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                retainedSelf.indeterminateLayer.path = path.CGPath
            }
        }
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(percentage, forKey: "percentage")
        aCoder.encodeInteger(progressRingWidth, forKey: "progressRingWidth")
        super.encodeWithCoder(aCoder)
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
            if indeterminate {
                toColor2 = successColor
            }
            break
        case .Failure:
            hidePercentage()
            drawFailure()
            toColor1 = failureColor
            if indeterminate {
                toColor2 = failureColor
            }
            break
        }
        
        if !animated {
            progressLayer.strokeColor = toColor1.CGColor
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustProgressRingWidth()

        // Percentage label
        if percentage {
            percentageLabel.frame = self.bounds
            percentageLabel.font = UIFont.systemFontOfSize(self.bounds.size.width / 5)
            percentageLabel.textColor = tintColor
        }
        
        // Update progress frame
        progressUpdate?()
    }
    
    public func adjustProgressRingWidth()
    {
        if progressRingWidth > 0 {
            adjustedProgressRingWidth = CGFloat(progressRingWidth)
        } else {
            adjustedProgressRingWidth = adjustedBackgroundRingWidth * 3.0
        }
        progressLayer.lineWidth = adjustedProgressRingWidth
    }
    
    //-------------------------------
    // MARK: Draw Functions
    //-------------------------------

    public func drawPercentage()
    {
        percentageLabel.text = percentageFormatter.stringFromNumber(self.progress)
    }
    
    public func hidePercentage()
    {
        percentageLabel.text = ""
    }
    
    //-------------------------------
    // MARK: Other
    //-------------------------------
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        progressLayer.fillColor = nil
        progressLayer.strokeColor = tintColor.CGColor
        percentageLabel.textColor = tintColor
    }
    
}
