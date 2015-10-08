//
//  M13ProgressSegmentedRing.swift
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
The segment boundary types.

- Wedge:
- Rectangle:
*/
public enum M13ProgressViewSegmentedRingSegmentBoundaryType: Int, RawRepresentable {
    ///
    case Wedge
    ///
    case Rectangle
}

/**
Progress is shown by a ring split up into segments.
*/
@IBDesignable
public class M13ProgressSegmentedRing: M13ProgressRing {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The number of segments to display in the progress view. 
    */
    @IBInspectable public var numberOfSegments: Int = 10
    
    /** 
    The angle of the separation between the segments in radians. 
    */
    @IBInspectable public var segmentSeparationAngle :CGFloat = 0.1
    
    /** 
    The type of boundary between segments. 
    */
    @IBInspectable public var segmentBoundaryType: M13ProgressViewSegmentedRingSegmentBoundaryType = .Wedge {
        didSet {
            updateAngles()
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
            indeterminateLayer.strokeColor = nil
            indeterminateLayer.fillColor = secondaryColor.CGColor
        }
    }
    
    //-------------------------------
    // MARK: Protected Variables
    //-------------------------------
    
    // The calculated angles of the concentric rings
    internal var outerRingAngle :CGFloat = 0.1
    internal var innerRingAngle :CGFloat = 0.1
    internal var segmentSeparationInnerAngle :CGFloat = 0.1
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValueForKey("numberOfSegments") {
            numberOfSegments = aDecoder.decodeIntegerForKey("numberOfSegments")
        }
        if aDecoder.containsValueForKey("segmentSeparationAngle") {
            segmentSeparationAngle = CGFloat(aDecoder.decodeDoubleForKey("segmentSeparationAngle"))
        }
        if aDecoder.containsValueForKey("segmentBoundaryType") {
            if let aSegmentBoundaryType = M13ProgressViewSegmentedRingSegmentBoundaryType(rawValue: aDecoder.decodeIntegerForKey("segmentBoundaryType")) {
                segmentBoundaryType = aSegmentBoundaryType
            }
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
        indeterminateLayer.strokeColor = nil
        indeterminateLayer.fillColor = secondaryColor.CGColor
        
        // Set up the progress layer
        progressLayer.strokeColor = nil
        progressLayer.fillColor = tintColor.CGColor
        
        adjustProgressRingWidth()
        
        // Set the progress animation.
        weak var weakSelf: M13ProgressSegmentedRing? = self
        progressUpdate = {() -> Void in
            
            if let retainedSelf = weakSelf {
                
                // Draw background
                retainedSelf.drawSegmentedBackground()
                
                // Draw progress ring
                retainedSelf.drawSegmentedProgress()
                
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
                
                let deltaAngle = CGFloat(frameDuration * M_PI)
                if retainedSelf.progressDirection == .CounterClockwise {
                    // CounterClockwise
                    retainedSelf.indeterminateAnimationAngle -= deltaAngle
                } else {
                    // Clockwise
                    retainedSelf.indeterminateAnimationAngle += deltaAngle
                }
                
                // Draw animated background
                retainedSelf.drawSegmentedIndeterminate(startAngle, segmentsToDraw: retainedSelf.numberOfSegments)
            }
        }
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(numberOfSegments, forKey: "numberOfSegments")
        aCoder.encodeDouble(Double(segmentSeparationAngle), forKey: "segmentSeparationAngle")
        aCoder.encodeInteger(segmentBoundaryType.rawValue, forKey: "segmentBoundaryType")
        super.encodeWithCoder(aCoder)
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------
    
    public override func setState(state: M13ProgressViewState, animated: Bool) {
        super.setState(state, animated: animated)

        // Remove strokeColor animations and assignments that were added during super.setState()
        progressLayer.removeAnimationForKey("strokeColor")
        progressLayer.strokeColor = nil
        indeterminateLayer.removeAnimationForKey("strokeColor")
        indeterminateLayer.strokeColor = nil
        
        // Select colors based on state
        var toColor1: UIColor = tintColor
        var toColor2: UIColor = secondaryColor
        switch state {
        case .Normal:
            break
        case .Success:
            toColor1 = successColor
            if indeterminate {
                toColor2 = successColor
            }
            break
        case .Failure:
            toColor1 = failureColor
            if indeterminate {
                toColor2 = failureColor
            }
            break
        }
        
        if !animated {
            progressLayer.fillColor = toColor1.CGColor
            indeterminateLayer.fillColor = toColor2.CGColor
        } else {
            let colorAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
            colorAnimation1.fromValue = progressLayer.backgroundColor!
            colorAnimation1.fillMode = kCAFillModeForwards
            colorAnimation1.removedOnCompletion = false
            colorAnimation1.duration = animationDuration
            
            let colorAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
            colorAnimation2.fromValue = indeterminateLayer.backgroundColor!
            colorAnimation2.fillMode = kCAFillModeForwards
            colorAnimation2.removedOnCompletion = false
            colorAnimation2.duration = animationDuration
            
            colorAnimation1.toValue = toColor1.CGColor
            progressLayer.addAnimation(colorAnimation1, forKey: "fillColor")
            progressLayer.fillColor = toColor1.CGColor
            
            colorAnimation2.toValue = toColor2.CGColor
            indeterminateLayer.addAnimation(colorAnimation2, forKey: "fillColor")
            indeterminateLayer.fillColor = toColor2.CGColor
        }
        
        setNeedsLayout()
        progressUpdate?()
    }
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateAngles()
        
        // Update progress frame
        progressUpdate?()
    }
    
    internal func updateAngles() {
        // Calculate the outer ring angle for the progress segment.
        outerRingAngle = CGFloat(2.0 * M_PI) / CGFloat(numberOfSegments) - segmentSeparationAngle
        // Calculate the angle gap for the inner ring
        let radius = maxRadius()
        segmentSeparationInnerAngle = 2.0 * asin((radius * sin(segmentSeparationAngle / 2.0)) / (radius - CGFloat(progressRingWidth)))
        // Calculate the inner ring angle for the progress segment.
        innerRingAngle = CGFloat(2.0 * M_PI) / CGFloat(numberOfSegments) - segmentSeparationInnerAngle
    }
    
    public func numberOfFullSegments() -> Int
    {
        return Int(floor(progress * CGFloat(numberOfSegments)))
    }
    
    //-------------------------------
    // MARK: Draw Functions
    //-------------------------------
    
    public func drawSegmentedIndeterminate(startAngle: CGFloat, segmentsToDraw: Int)
    {
        // Create parameters to draw background
        // The background segments are drawn counterclockwise, start with the outer ring, add an arc counterclockwise.  Then add the coresponding arc for the inner ring clockwise. Then close the path. The line connecting the two arcs is not needed. From tests it seems to be created automatically.
        var outerStartAngle = CGFloat(-M_PI_2) + startAngle
        // Skip half of a separation angle, since the first separation will be centered upward.
        outerStartAngle -= segmentSeparationAngle / 2.0
        // Calculate the inner start angle position
        var innerStartAngle = CGFloat(-M_PI_2) + startAngle
        innerStartAngle -= segmentSeparationInnerAngle / 2.0 + innerRingAngle

        // Create the path ref that all the paths will be appended
        let pathListRef = CGPathCreateMutable()
        
        // Create each segment
        let center = centerOfCircle()
        let radius = maxRadius()
        let radiusInner = radius - CGFloat(progressRingWidth)
        for (var i = 0; i < segmentsToDraw; ++i) {
            // Create the outer ring segment
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: outerStartAngle, endAngle: (outerStartAngle - outerRingAngle), clockwise: false)
            // Create the inner ring segment
            if (segmentBoundaryType == .Wedge) {
                path.addArcWithCenter(center, radius: radiusInner, startAngle: (outerStartAngle - outerRingAngle), endAngle: outerStartAngle, clockwise: true)
            } else if (segmentBoundaryType == .Rectangle) {
                path.addArcWithCenter(center, radius: radiusInner, startAngle: innerStartAngle, endAngle: (innerStartAngle + innerRingAngle), clockwise: true)
            }
            
            path.closePath()
            // Add the segment to the path ref
            CGPathAddPath(pathListRef, nil, path.CGPath)
            
            // Setup for the next segment
            outerStartAngle -= outerRingAngle + segmentSeparationAngle
            innerStartAngle -= innerRingAngle + segmentSeparationInnerAngle
        }
        
        // Set the path
        indeterminateLayer.path = pathListRef
        
        indeterminateLayer.transform = getTransformation()
    }
    
    public func drawSegmentedBackground()
    {
        let segmentsToDraw = numberOfSegments - numberOfFullSegments()
        drawSegmentedIndeterminate(0, segmentsToDraw: segmentsToDraw)
    }
    
    public func drawSegmentedProgress()
    {
        // Create parameters to draw background
        // The progress segments are drawn clockwise, start with the outer ring, add an arc clockwise.  Then add the coresponding arc for the inner ring counterclockwise. Then close the path. The line connecting the two arcs is not needed. From tests it seems to be created automatically.
        var outerStartAngle = CGFloat(-M_PI_2)
        // Skip half of a separation angle, since the first separation will be centered upward.
        outerStartAngle += segmentSeparationAngle / 2.0
        // Calculate the inner start angle position
        var innerStartAngle = CGFloat(-M_PI_2)
        innerStartAngle += segmentSeparationInnerAngle / 2.0 + innerRingAngle

        // Create the path ref that all the paths will be appended
        let pathListRef = CGPathCreateMutable()

        // Create each segment
        let center = centerOfCircle()
        let radius = maxRadius()
        let radiusInner = radius - CGFloat(progressRingWidth)
        let stopper = numberOfFullSegments()
        for (var i = 0; i < stopper; ++i) {
            // Create the outer ring segment
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: outerStartAngle, endAngle: (outerStartAngle + outerRingAngle), clockwise: true)
            // Create the inner ring segment
            if (segmentBoundaryType == .Wedge) {
                path.addArcWithCenter(center, radius: radiusInner, startAngle: (outerStartAngle + outerRingAngle), endAngle: outerStartAngle, clockwise: false)
            } else if (segmentBoundaryType == .Rectangle) {
                path.addArcWithCenter(center, radius: radiusInner, startAngle: innerStartAngle, endAngle: (innerStartAngle - innerRingAngle), clockwise: false)
            }
            
            path.closePath()
            // Add the segment to the path ref
            CGPathAddPath(pathListRef, nil, path.CGPath)
            
            // Setup for the next segment
            outerStartAngle += outerRingAngle + segmentSeparationAngle
            innerStartAngle += innerRingAngle + segmentSeparationInnerAngle
        }
        
        // Set the path
        progressLayer.path = pathListRef
        
        progressLayer.transform = getTransformation()
    }
    
    public func getTransformation() -> CATransform3D
    {
        if progressDirection == .CounterClockwise {
            let rotation = CATransform3DMakeRotation(CGFloat(M_PI), 0.0, 1.0, 0.0)
            let x = self.bounds.size.width
            let translation = CATransform3DMakeTranslation(x, 0, 0)
            return CATransform3DConcat(rotation, translation)
        }
        
        return CATransform3DIdentity
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
