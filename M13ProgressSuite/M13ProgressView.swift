    //
    //  M13ProgressView.swift
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
    The possible states a progress view can be in.

    - None: The default state of a progress bar.
    - Success: The state that shows an action completed successfully.
    - Failure: The state that shows an action failed to complete.
    */
    public enum M13ProgressViewState: Int, RawRepresentable {
        /// The default state of a progress bar.
        case Normal
        /// The state that shows an action completed successfully.
        case Success
        /// The state that shows an action failed to complete.
        case Failure
    }

    /**
    A standardized base upon which to build progress views.
    */
    @IBDesignable
    public class M13ProgressView: UIView {

        //-------------------------------
        // MARK: Appearance
        //-------------------------------
        
        /**
        The secondary color of the progress view.
        */
        @IBInspectable public var secondaryColor: UIColor = UIColor.lightGrayColor()
        
        /**
        The primary color when the progress view is in the success state.
        */
        @IBInspectable public var successColor: UIColor = UIColor(red: 63.0/255.0, green: 226.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        /**
        The primary color when the progress view is in the failure state.
        */
        @IBInspectable public var failureColor: UIColor = UIColor(red: 249.0/255.0, green: 37.0/255.0, blue: 0.0, alpha: 1.0)
        
        
        //-------------------------------
        // MARK: Properties
        //-------------------------------
        
        /**
        Wether or not the progress view is in an indeterminate state.
        */
        @IBInspectable public var indeterminate: Bool = false {
            didSet {
                if indeterminate && indeterminateDisplayLink == nil {
                    // Create the display link
                    indeterminateDisplayLink = CADisplayLink(target: self, selector: "animateIndeterminate:")
                    indeterminateDisplayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
                } else if !indeterminate && indeterminateDisplayLink != nil {
                    // Remove the display link as the animation is not needed anymore.
                    indeterminateDisplayLink?.invalidate()
                    indeterminateDisplayLink = nil
                }
            }
        }
        
        /**
        The duration of the animations performed by the progress view in seconds.
        */
        @IBInspectable public var animationDuration: NSTimeInterval = 0.3
        
        /**
        The duration of the indeterminate animation loop in seconds.
        */
        @IBInspectable public var indeterminateAnimationDuration: NSTimeInterval = 2.0
        
        /**
        The progress displayed by the progress view.
        */
        @IBInspectable public private(set) var progress: CGFloat = 0.0 
        
        /**
        The current state of the progress view
        */
        @IBInspectable public private(set) var state: M13ProgressViewState = M13ProgressViewState.Normal
        
        //-------------------------------
        // MARK: Animation
        //-------------------------------
        
        /**
        The progress at the beginning of the animation.
        */
        private var progressFromValue: CGFloat = 0.0
        
        /**
        The progress at the end of the animation.
        */
        private var progressToValue: CGFloat = 0.0
        
        /**
        The start time of the animation.
        */
        private var animationStartTime: CFTimeInterval?
        
        /**
        The display link controlling progress animations.
        */
        private var determinateDisplayLink: CADisplayLink?
        
        /**
        The display link controlling indeterminate animations.
        */
        private var indeterminateDisplayLink: CADisplayLink?
        
        /**
        The block of code that updates the user interface when the progress is set, animated or not. The changes made should reflect the current value of the progress variable.
        
        - note: If capturing variable that is linked to `self`, be sure to do a "weak self" conversion.
        */
        internal var progressUpdate: (() -> Void)?
        
        /**
        The block of code that update the user interface during the indeterminate state. This code is tied into a CADisplayLink that will run this code each frame.
        
        - note: If capturing variable that is linked to `self`, be sure to do a "weak self" conversion.
        */
        internal var indeterminateUpdate: ((frameDuration: CFTimeInterval) -> Void)?
        
        //-------------------------------
        // MARK: Initalization
        //-------------------------------
        
        public init() {
            super.init(frame: CGRectZero)
        }

        required public init?(coder aDecoder: NSCoder) {
            if aDecoder.containsValueForKey("indeterminate") {
                indeterminate = aDecoder.decodeBoolForKey("indeterminate")
            }
            if aDecoder.containsValueForKey("animationDuration") {
                animationDuration = aDecoder.decodeDoubleForKey("animationDuration")
            }
            if aDecoder.containsValueForKey("progress") {
                progress = CGFloat(aDecoder.decodeFloatForKey("progress"))
            }
            if aDecoder.containsValueForKey("state") {
                if let aState = M13ProgressViewState(rawValue: aDecoder.decodeIntegerForKey("state")) {
                    state = aState
                }
            }
            if let color: UIColor = aDecoder.decodeObjectOfClass(UIColor.self, forKey: "secondaryColor") {
                secondaryColor = color
            }
            if let color: UIColor = aDecoder.decodeObjectOfClass(UIColor.self, forKey: "successColor") {
                successColor = color
            }
            if let color: UIColor = aDecoder.decodeObjectOfClass(UIColor.self, forKey: "failureColor") {
                failureColor = color
            }
            
            super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        
        public override func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(secondaryColor, forKey: "secondaryColor")
            aCoder.encodeObject(successColor, forKey: "successColor")
            aCoder.encodeObject(failureColor, forKey: "failureColor")
            aCoder.encodeBool(indeterminate, forKey: "indeterminate")
            aCoder.encodeDouble(animationDuration, forKey: "animationDuration")
            aCoder.encodeFloat(Float(progress), forKey: "progress")
            aCoder.encodeInteger(state.rawValue, forKey: "state")
            super.encodeWithCoder(aCoder)
        }
        
        //-------------------------------
        // MARK: Actions
        //-------------------------------
        
        /**
        Set the progress displayed in the progress view.
        
        - parameter progress: The progress to be displayed by the progress view.
        - parameter animated: Wether or not to animate the change.
        */
        public func setProgress(progress: CGFloat, animated: Bool) {
            
            if animated == false {
                // Remove the display link as the animation is not needed anymore.
                determinateDisplayLink?.invalidate()
                determinateDisplayLink = nil
                animationStartTime = nil
                // Update the progress
                self.progress = progress
                progressUpdate?()
            } else {
                // If the display link does not exist, create it.
                if determinateDisplayLink == nil {
                    determinateDisplayLink = CADisplayLink(target: self, selector: "animateProgress:")
                    determinateDisplayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
                }
                
                // Update the values for the animation.
                progressFromValue = self.progress
                progressToValue = progress > 1.0 ? 1.0 : progress
            }
        }
        
        /**
        Updates the progress in sync with the `CADisplayLink`, such that any changes are animated.
        
        - parameter displayLink: The display link that is asking to calculate changes before the next render cycle.
        */
        internal func animateProgress(displayLink: CADisplayLink) {
            
            // Set the animation start time on the first displayed frame. The timestamp will read 0.0 until the first frame.
            if animationStartTime == nil {
                animationStartTime = displayLink.timestamp
                return
            }
            
            weak var weakSelf: M13ProgressView? = self
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if let weakSelf = weakSelf {
                    let dt: Double = (weakSelf.determinateDisplayLink!.timestamp - weakSelf.animationStartTime!) / weakSelf.animationDuration
                    if dt >= 1.0 {
                        // The animation is complete.
                        // Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
                        weakSelf.determinateDisplayLink?.invalidate()
                        weakSelf.determinateDisplayLink = nil
                        weakSelf.setProgress(weakSelf.progressToValue, animated: false)
                    } else {
                        //Update the progress and the display
                        weakSelf.progress = weakSelf.progressFromValue + (CGFloat(dt) * (weakSelf.progressToValue - weakSelf.progressFromValue))
                        weakSelf.progressUpdate?()
                    }
                }
            }
        }
        
        /**
        Updates the indeterminate animation in sync with the `CADisplayLink`, such that any changes are animated.
        
        - parameter displayLink: The display link that is asking to calculate changes before the next render cycle.
        */
        internal func animateIndeterminate(displayLink: CADisplayLink) {
            weak var weakSelf: M13ProgressView? = self
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                weakSelf?.indeterminateUpdate?(frameDuration: displayLink.duration)
            }
        }
        
        /**
        Perform the given action. 
        
        - note: Not all progress views support all actions.
        - seealso: `M13ProgressViewState`
        
        - parameter action: The action to perform.
        - parameter animated: Wether or not to animate the change.
        */
        public func setState(state: M13ProgressViewState, animated: Bool) {
            self.state = state
        }

        //-------------------------------
        // MARK: Layout and Drawing
        //-------------------------------
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            // Just update the progress in case it is not currently animating. The indeterminate animation will update on the next frame.
            progressUpdate?()
        }
        
    }
