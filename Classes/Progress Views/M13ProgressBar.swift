//
//  M13ProgressBar.swift
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
The possible directions a progress bar can travel in.

- LeadingToTrailing: The progress bar will travel from leading to trailing as the progress nears completion.
- TrailingToLeading: The progress bar will travel from trailing to leading as the progress nears completion.
- BottomToTop: The progress bar will travel from the bottom to the top as the progress nears completion.
- TopToBottom: The progress bar will travel from the top to the bottom as the progress nears completion.
*/
public enum M13ProgressBarProgressDirection: Int, RawRepresentable {
    /// The progress bar will travel from leading to trailing as the progress nears completion.
    case LeadingToTrailing
    /// The progress bar will travel from trailing to leading as the progress nears completion.
    case TrailingToLeading
    /// The progress bar will travel from the bottom to the top as the progress nears completion.
    case BottomToTop
    /// The progress bar will travel from the top to the bottom as the progress nears completion.
    case TopToBottom
    
}

/**
A simple progress bar similar to UIProgressBar, but with an indeterminate state.
*/
@IBDesignable
public class M13ProgressBar: M13ProgressView {
    
    //-------------------------------
    // MARK: Appearance
    //-------------------------------
    
    /**
    The corner radius of the progress bar.
    */
    @IBInspectable public var cornerRadius: CGFloat = CGFloat.max {
        didSet {
            var appropiateCornerRadius: CGFloat = frame.size.width < frame.size.height ? frame.size.width / 2.0 : frame.size.height / 2.0
            appropiateCornerRadius = appropiateCornerRadius > cornerRadius ? cornerRadius : appropiateCornerRadius
            layer.cornerRadius = appropiateCornerRadius
            progressLayer.cornerRadius = appropiateCornerRadius
            indeterminateLayer.cornerRadius = appropiateCornerRadius
        }
    }
    
    /**
    The secondary color of the progress view.
    */
    override public var secondaryColor: UIColor {
        didSet {
            layer.backgroundColor = secondaryColor.CGColor
        }
    }
    
    /**
    The primary color when the progress view is in the success state.
    */
    override public var successColor: UIColor {
        didSet {
            if state == M13ProgressViewState.Success {
                progressLayer.backgroundColor = successColor.CGColor
                indeterminateLayer.backgroundColor = successColor.CGColor
            }
        }
    }
    
    /**
    The primary color when the progress view is in the failure state.
    */
    override public var failureColor: UIColor {
        didSet {
            if state == M13ProgressViewState.Failure {
                progressLayer.backgroundColor = failureColor.CGColor
                indeterminateLayer.backgroundColor = failureColor.CGColor
            }
        }
    }
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The direction the progress bar travels in as the progress nears completion.
    */
    @IBInspectable public var progressDirection: M13ProgressBarProgressDirection = M13ProgressBarProgressDirection.LeadingToTrailing {
        didSet {
            progressUpdate?()
        }
    }
    
    /**
    The layer that makes up the progress bar.
    */
    private var progressLayer: CALayer = CALayer()
    
    /**
    The layer that makes up the indeterminate progress bar.
    */
    private var indeterminateLayer: CAShapeLayer = CAShapeLayer()
    
    override public var indeterminate: Bool {
        didSet {
            // Add the indeterminate layer.
            if indeterminate && indeterminateLayer.superlayer == nil {
                progressLayer.removeFromSuperlayer()
                layer.addSublayer(indeterminateLayer)
            }
            
            // Add the progress layer
            if !indeterminate && progressLayer.superlayer == nil {
                indeterminateLayer.removeFromSuperlayer()
                layer.addSublayer(progressLayer)
            }
        }
    }
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValueForKey("cornerRadius") {
            cornerRadius = CGFloat(aDecoder.decodeDoubleForKey("cornerRadius"))
        }
        if aDecoder.containsValueForKey("progressDirection") {
            if let direction = M13ProgressBarProgressDirection(rawValue: aDecoder.decodeIntegerForKey("progressDirection")) {
                progressDirection = direction
            }
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
        self.clipsToBounds = true
        
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = secondaryColor.CGColor
        
        progressLayer.cornerRadius = cornerRadius
        indeterminateLayer.cornerRadius = cornerRadius
        progressLayer.backgroundColor = tintColor.CGColor
        indeterminateLayer.backgroundColor = tintColor.CGColor
        
        // Disable default animations
        progressLayer.actions = [
            "frame": NSNull(),
            "anchorPoint": NSNull(),
            "bounds": NSNull(),
            "position": NSNull(),
            "cornerRadius": NSNull()
        ]
        indeterminateLayer.actions = [
            "frame": NSNull(),
            "anchorPoint": NSNull(),
            "bounds": NSNull(),
            "position": NSNull(),
            "cornerRadius": NSNull()
        ]
        
        
        // Add the layers
        self.layer.addSublayer(progressLayer)
        
        // Set the progress and indeterminate animations.
        weak var weakSelf: M13ProgressBar? = self;
        progressUpdate = {() -> Void in

            if let weakSelf = weakSelf {
                // Get the frame of the progress layer
                var progressFrame: CGRect = CGRectZero
                switch weakSelf.progressDirection {
                case .LeadingToTrailing:
                    if #available(iOS 9.0, *) {
                        let xPosition = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(UISemanticContentAttribute.Spatial) == UIUserInterfaceLayoutDirection.LeftToRight ? 0.0 : weakSelf.frame.size.width - (weakSelf.frame.size.width * weakSelf.progress)
                        progressFrame = CGRectMake(xPosition, 0.0, weakSelf.frame.size.width * weakSelf.progress, weakSelf.frame.size.height)
                    } else {
                        let xPosition = NSLocale.characterDirectionForLanguage(NSLocale.preferredLanguages().first!) != NSLocaleLanguageDirection.RightToLeft ? 0.0 : weakSelf.frame.size.width - (weakSelf.frame.size.width * weakSelf.progress)
                        progressFrame = CGRectMake(xPosition, 0.0, weakSelf.frame.size.width * weakSelf.progress, weakSelf.frame.size.height)
                    }
                    break
                case .TrailingToLeading:
                    if #available(iOS 9.0, *) {
                        let xPosition = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(UISemanticContentAttribute.Spatial) == UIUserInterfaceLayoutDirection.RightToLeft ? 0.0 : weakSelf.frame.size.width - (weakSelf.frame.size.width * weakSelf.progress)
                        progressFrame = CGRectMake(xPosition, 0.0, weakSelf.frame.size.width * weakSelf.progress, weakSelf.frame.size.height)
                    } else {
                        let xPosition = NSLocale.characterDirectionForLanguage(NSLocale.preferredLanguages().first!) == NSLocaleLanguageDirection.RightToLeft ? 0.0 : weakSelf.frame.size.width - (weakSelf.frame.size.width * weakSelf.progress)
                        progressFrame = CGRectMake(xPosition, 0.0, weakSelf.frame.size.width * weakSelf.progress, weakSelf.frame.size.height)
                    }
                    break
                case .BottomToTop:
                    progressFrame = CGRectMake(0.0, weakSelf.frame.size.height - (weakSelf.frame.size.height * weakSelf.progress), weakSelf.frame.size.width, weakSelf.frame.size.height * weakSelf.progress)
                    break
                case .TopToBottom:
                    progressFrame = CGRectMake(0.0, 0.0, weakSelf.frame.size.width, weakSelf.frame.size.height * weakSelf.progress)
                    break
                }
                weakSelf.progressLayer.frame = progressFrame
            }
        }
        
        indeterminateUpdate = {(frameDuration: CFTimeInterval) -> Void in
            
            if let weakSelf = weakSelf {
                
                let horizontallyTraveling: Bool = weakSelf.progressDirection == M13ProgressBarProgressDirection.LeadingToTrailing || weakSelf.progressDirection == M13ProgressBarProgressDirection.TrailingToLeading
                
                let barPosition: CGFloat = horizontallyTraveling ? weakSelf.indeterminateLayer.frame.origin.x : weakSelf.indeterminateLayer.frame.origin.y
                let barLength: CGFloat = horizontallyTraveling ? weakSelf.frame.size.width * 0.2 : weakSelf.frame.size.height * 0.2
                
                let totalTravelDistance: CGFloat = horizontallyTraveling ? weakSelf.frame.size.width + (2.0 * barLength) : weakSelf.frame.size.height + (2.0 * barLength)
                let totalTravelTime: NSTimeInterval = weakSelf.animationDuration * 6.0
                let totalAnimationFrames: CGFloat = CGFloat(totalTravelTime) / CGFloat(frameDuration)
                let travelDelta: CGFloat = totalTravelDistance / totalAnimationFrames
                
                // Set the new frame of the bar: either move it by the travel delta, or move it back to the begining.
                switch weakSelf.progressDirection {
                case .LeadingToTrailing:
                    var leftToRight: Bool = true;
                    if #available(iOS 9.0, *) {
                        leftToRight = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(UISemanticContentAttribute.Spatial) == UIUserInterfaceLayoutDirection.LeftToRight
                    } else {
                        leftToRight = NSLocale.characterDirectionForLanguage(NSLocale.preferredLanguages().first!) != NSLocaleLanguageDirection.RightToLeft
                    }
                    if leftToRight {
                        if barPosition >= weakSelf.frame.size.width {
                            weakSelf.indeterminateLayer.frame = CGRectMake(-barLength, 0.0, barLength, weakSelf.frame.size.height)
                        } else {
                            weakSelf.indeterminateLayer.frame = CGRectMake(weakSelf.indeterminateLayer.frame.origin.x + travelDelta, 0.0, barLength, weakSelf.frame.size.height)
                        }
                    } else {
                        if barPosition <= -barLength {
                            weakSelf.indeterminateLayer.frame = CGRectMake(weakSelf.frame.size.width, 0.0, barLength, weakSelf.frame.size.height)
                        } else {
                            weakSelf.indeterminateLayer.frame = CGRectMake(weakSelf.indeterminateLayer.frame.origin.x - travelDelta, 0.0, barLength, weakSelf.frame.size.height)
                        }
                    }
                    break
                case .TrailingToLeading:
                    var rightToLeft: Bool = true;
                    if #available(iOS 9.0, *) {
                        rightToLeft = UIView.userInterfaceLayoutDirectionForSemanticContentAttribute(UISemanticContentAttribute.Spatial) == UIUserInterfaceLayoutDirection.RightToLeft
                    } else {
                        rightToLeft = NSLocale.characterDirectionForLanguage(NSLocale.preferredLanguages().first!) == NSLocaleLanguageDirection.RightToLeft
                    }
                    if rightToLeft {
                        if barPosition <= -barLength {
                            weakSelf.indeterminateLayer.frame = CGRectMake(weakSelf.frame.size.width, 0.0, barLength, weakSelf.frame.size.height)
                        } else {
                            weakSelf.indeterminateLayer.frame = CGRectMake(weakSelf.indeterminateLayer.frame.origin.x - travelDelta, 0.0, barLength, weakSelf.frame.size.height)
                        }
                    } else {
                        if barPosition >= weakSelf.frame.size.width {
                            weakSelf.indeterminateLayer.frame = CGRectMake(-barLength, 0.0, barLength, weakSelf.frame.size.height)
                        } else {
                            weakSelf.indeterminateLayer.frame = CGRectMake(weakSelf.indeterminateLayer.frame.origin.x + travelDelta, 0.0, barLength, weakSelf.frame.size.height)
                        }
                    }
                    break
                case .BottomToTop:
                    if barPosition <= -barLength {
                        weakSelf.indeterminateLayer.frame = CGRectMake(0.0, weakSelf.frame.size.height, weakSelf.frame.size.width, barLength)
                    } else {
                        weakSelf.indeterminateLayer.frame = CGRectMake(0.0, weakSelf.indeterminateLayer.frame.origin.y - travelDelta, weakSelf.frame.size.width, barLength)
                    }
                    break
                case .TopToBottom:
                    if barPosition >= weakSelf.frame.size.height {
                        weakSelf.indeterminateLayer.frame = CGRectMake(0.0, -barLength, weakSelf.frame.size.width, barLength)
                    } else {
                        weakSelf.indeterminateLayer.frame = CGRectMake(0.0, weakSelf.indeterminateLayer.frame.origin.y + travelDelta, weakSelf.frame.size.width, barLength)
                    }
                    break
                }
            }
        }
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(Double(cornerRadius), forKey: "cornerRadius")
        aCoder.encodeInteger(progressDirection.rawValue, forKey: "progressDirection")
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
        
        if !animated {
            switch state {
            case .Normal:
                progressLayer.backgroundColor = tintColor.CGColor
                indeterminateLayer.backgroundColor = tintColor.CGColor
                break
            case .Success:
                progressLayer.backgroundColor = successColor.CGColor
                indeterminateLayer.backgroundColor = successColor.CGColor
                break
            case .Failure:
                progressLayer.backgroundColor = failureColor.CGColor
                indeterminateLayer.backgroundColor = failureColor.CGColor
                break
            }
        } else {
            let colorAnimation: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
            colorAnimation.fromValue = progressLayer.backgroundColor!
            colorAnimation.fillMode = kCAFillModeForwards
            colorAnimation.removedOnCompletion = false
            colorAnimation.duration = animationDuration
            
            var toColor: UIColor = tintColor
            switch state {
            case .Normal:
                toColor = tintColor
                break
            case .Success:
                toColor = successColor
                break
            case .Failure:
                toColor = failureColor
                break
            }
            
            colorAnimation.toValue = toColor.CGColor
            progressLayer.addAnimation(colorAnimation, forKey: "backgroundColor")
            indeterminateLayer.addAnimation(colorAnimation, forKey: "backgroundColor")
            progressLayer.backgroundColor = toColor.CGColor
            indeterminateLayer.backgroundColor = toColor.CGColor
            
        }
    }
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //Update the corner radius
        var appropiateCornerRadius: CGFloat = frame.size.width < frame.size.height ? frame.size.width / 2.0 : frame.size.height / 2.0
        appropiateCornerRadius = appropiateCornerRadius > cornerRadius ? cornerRadius : appropiateCornerRadius
        layer.cornerRadius = appropiateCornerRadius
        progressLayer.cornerRadius = appropiateCornerRadius
        indeterminateLayer.cornerRadius = appropiateCornerRadius
        //Update progress frame
        progressUpdate?()
    }
    
    //-------------------------------
    // MARK: Other
    //-------------------------------
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        progressLayer.backgroundColor = tintColor.CGColor
        indeterminateLayer.backgroundColor = tintColor.CGColor
    }
    
}
