//
//  M13ProgressPie.swift
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
A progress view that shows progress with a pie chart.
*/
@IBDesignable
public class M13ProgressPie: M13ProgressCircular {
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    override internal func sharedSetup() {
        super.sharedSetup()
        
        // Set the defaults.
        self.clipsToBounds = false
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        // Set the progress animation.
        weak var weakSelf: M13ProgressPie? = self
        progressUpdate = {() -> Void in
            
            if let retainedSelf = weakSelf {
                
                // Create parameters to draw ring
                var startAngle = CGFloat(-M_PI_2)
                var endAngle = startAngle + (2.0 * CGFloat(M_PI) * retainedSelf.progress)
                
                let clockwise = (retainedSelf.progressDirection == .Clockwise)
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
                let radius = retainedSelf.maxRadius()
                let path = retainedSelf.createPieSlicePath(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                retainedSelf.progressLayer.path = path.CGPath
            }
        }
        
        // Set the indeterminate animation.
        indeterminateUpdate = {(frameDuration: CFTimeInterval) -> Void in
            
            if let retainedSelf = weakSelf {
                
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
                
                // Draw background
                retainedSelf.drawBackground()
                
                // Draw path
                let center = retainedSelf.centerOfCircle()
                let radius = retainedSelf.maxRadius()
                let path = retainedSelf.createPieSlicePath(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                retainedSelf.progressLayer.path = path.CGPath
            }
        }
    }
    
}

