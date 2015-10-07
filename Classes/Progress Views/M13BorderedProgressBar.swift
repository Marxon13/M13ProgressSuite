//
//  M13BorderedProgressBar.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 9/13/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

/**
A wrapper around M13ProgressBar that adds a border around the bar.
*/
@IBDesignable
public class M13BorderedProgressBar: M13ProgressView {

    //-------------------------------
    // MARK: Appearance
    //-------------------------------
    
    /**
    The corner radius of the progress bar.
    */
    @IBInspectable public var cornerRadius: CGFloat = CGFloat.max {
        didSet {
            progressBar.cornerRadius = cornerRadius
        }
    }
    
    /**
    The width of the border around the progress bar.
    */
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            borderView.layer.borderWidth = borderWidth
        }
    }
    
    /**
    The spacing between the border and the progress bar.
    */
    @IBInspectable public var borderPadding: CGFloat = 1.0
    
    override public var secondaryColor: UIColor {
        didSet {
            progressBar.secondaryColor = secondaryColor
        }
    }
    
    override public var successColor: UIColor {
        didSet {
            progressBar.successColor = successColor
            if state == M13ProgressViewState.Success {
                borderView.layer.borderColor = successColor.CGColor
            }
        }
    }
    
    override public var failureColor: UIColor {
        didSet {
            progressBar.failureColor = failureColor
            if state == M13ProgressViewState.Failure {
                borderView.layer.borderColor = failureColor.CGColor
            }
        }
    }
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The progress bar that displays the progress.
    */
    public var progressBar: M13ProgressBar = M13ProgressBar() {
        willSet(newValue) {
            // Remove the current progress bar from the view.
            progressBar.removeFromSuperview()
        }
        didSet(oldValue) {
            // Set the current parameters
            progressBar.cornerRadius = cornerRadius
            progressBar.secondaryColor = secondaryColor
            progressBar.successColor = successColor
            progressBar.failureColor = failureColor
            progressBar.progressDirection = progressDirection
            progressBar.indeterminate = indeterminate
            // Add the new progress bar to the view.
            addSubview(progressBar)
        }
    }
    
    
    /**
    The view that displays the border layer.
    */
    private var borderView: UIView = UIView()
    
    /**
    The direction the progress bar travels in as the progress nears completion.
    */
    @IBInspectable public var progressDirection: M13ProgressBarProgressDirection = M13ProgressBarProgressDirection.LeadingToTrailing {
        didSet {
            progressBar.progressDirection = progressDirection
        }
    }
    
    override public var indeterminate: Bool {
        didSet {
            progressBar.indeterminate = indeterminate
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
        if aDecoder.containsValueForKey("borderWidth") {
            borderWidth = CGFloat(aDecoder.decodeDoubleForKey("borderWidth"))
        }
        if aDecoder.containsValueForKey("borderPadding") {
            borderWidth = CGFloat(aDecoder.decodeDoubleForKey("borderPadding"))
        }
        if aDecoder.containsValueForKey("progressBar") {
            progressBar = aDecoder.decodeObjectOfClass(M13ProgressBar.self, forKey: "progressBar")!
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
        //self.clipsToBounds = true
        
        // Set border
        borderView.clipsToBounds = true
        borderView.layer.borderColor = tintColor.CGColor
        borderView.layer.borderWidth = borderWidth
        borderView.backgroundColor = UIColor.clearColor()
        
        // Set background
        secondaryColor = UIColor.clearColor()
        
        // Add views
        addSubview(progressBar)
        addSubview(borderView)
        
        // Set the progress and indeterminate animations.
        weak var weakSelf: M13BorderedProgressBar? = self;
        progressUpdate = {() -> Void in
            if let weakSelf = weakSelf {
                weakSelf.progressBar.setProgress(weakSelf.progress, animated: false)
            }
        }
        
        indeterminateUpdate = {(frameDuration: CFTimeInterval) -> Void in
            weakSelf?.progressBar.indeterminateUpdate?(frameDuration: frameDuration)
        }
        
        setNeedsLayout()
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(Double(borderWidth), forKey: "borderWidth")
        aCoder.encodeDouble(Double(borderPadding), forKey: "borderPadding")
        aCoder.encodeObject(progressBar, forKey: "progressBar")
    }
    
    public override func prepareForInterfaceBuilder() {
        sharedSetup()
        super.prepareForInterfaceBuilder()
    }
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake((borderWidth * 2) + (borderPadding * 2), (borderWidth * 2) + (borderPadding * 2))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Update the corner radius
        var appropiateCornerRadius: CGFloat = frame.size.width < frame.size.height ? frame.size.width / 2.0 : frame.size.height / 2.0
        appropiateCornerRadius = appropiateCornerRadius > cornerRadius ? cornerRadius : appropiateCornerRadius
        borderView.layer.cornerRadius = appropiateCornerRadius
        // Layout
        borderView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        progressBar.frame = CGRectMake(borderWidth + borderPadding, borderWidth + borderPadding, frame.size.width - (2 * (borderWidth + borderPadding)), frame.size.height - (2 * (borderWidth + borderPadding)))
        // Update progress
        progressUpdate?()
    }
    
    //-------------------------------
    // MARK: Other
    //-------------------------------
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        borderView.layer.borderColor = tintColor.CGColor
    }
}
