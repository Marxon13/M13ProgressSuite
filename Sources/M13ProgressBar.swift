//
//  M13ProgressBar.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon (NonEmp) on 8/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

/**
 The possible directions a progress bar can travel in.
 
 - **leadingToTrailing**: The progress bar will travel from leading to trailing as the progress nears completion.
 - **trailingToLeading**: The progress bar will travel from trailing to leading as the progress nears completion.
 - **bottomToTop**: The progress bar will travel from the bottom to the top as the progress nears completion.
 - **topToBottom**: The progress bar will travel from the top to the bottom as the progress nears completion.
 */
public enum M13ProgressBarProgressDirection: Int, RawRepresentable {
    /// The progress bar will travel from leading to trailing as the progress nears completion.
    case leadingToTrailing
    /// The progress bar will travel from trailing to leading as the progress nears completion.
    case trailingToLeading
    /// The progress bar will travel from the bottom to the top as the progress nears completion.
    case bottomToTop
    /// The progress bar will travel from the top to the bottom as the progress nears completion.
    case topToBottom
    
}

/**
 A simple progress bar that can display determinate and indeterminate progress.
 */
@IBDesignable
public class M13ProgressBar: M13ProgressViewBase, M13ProgressViewMultipleType {
    
    // ---------------------------------
    // MARK: - Initalization
    // ---------------------------------
    
    override init() {
        super.init(frame: CGRect.zero)
        sharedSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        cornerRadius = CGFloat(aDecoder.decodeDouble(forKey: "cornerRadius"))
        if let direction = aDecoder.decodeObject(forKey: "progressDirection") as? String {
            _IBprogressDirection = direction
        }
        sharedSetup()
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(cornerRadius, forKey: "cornerRadius")
        aCoder.encode(_IBprogressDirection, forKey: "progressDirection")
    }
    
    override func sharedSetup() {
        super.sharedSetup()
        
        // Setup the defaults
        clipsToBounds = true
        
        setAppropiateCornerRadius()
        
        layer.backgroundColor = secondaryTintColor?.cgColor
        progressLayer.backgroundColor = tintColor.cgColor
        
        progressLayer.actions = [
            "frame": NSNull(),
            "anchorPoint": NSNull(),
            "bounds": NSNull(),
            "position": NSNull(),
            "cornerRadius": NSNull()
        ]
        
        layer.addSublayer(progressLayer)
    }
    
    public override func prepareForInterfaceBuilder() {
        sharedSetup()
        super.prepareForInterfaceBuilder()
    }
    
    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------
    
    @IBInspectable override public var secondaryTintColor: UIColor? {
        didSet {
            layer.backgroundColor = secondaryTintColor?.cgColor
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = CGFloat.greatestFiniteMagnitude {
        didSet {
            setAppropiateCornerRadius()
        }
    }
    
    public var progressDirection: M13ProgressBarProgressDirection = .leadingToTrailing {
        didSet {
            
        }
    }
    
    @IBInspectable public var determinateProgressAnimationDuration: TimeInterval = 0.3 {
        didSet {
            
        }
    }
    
    @IBInspectable public var indeterminateProgressAnimationDuration: TimeInterval = 1.0 {
        didSet {
            
        }
    }
    
    // ---------------------------------
    // MARK: - Progress
    // ---------------------------------
    
    private var _progress: CGFloat = 0.0
    @IBInspectable public var progress: CGFloat {
        get {
            return _progress
        }
        set {
            setProgress(newValue, animated: false, completion: nil)
        }
    }
    
    public func setProgress(_ progress: CGFloat, animated: Bool, completion: ((progress: CGFloat) -> Void)?) {
        
    }
    
    private var _type: M13ProgressType = .determinate
    public var type: M13ProgressType {
        get {
            return _type
        }
        set {
            setType(newValue, animated: false, completion: nil)
        }
    }
    
    public func setType(_ type: M13ProgressType, animated: Bool, completion: ((type: M13ProgressType) -> Void)?) {
        
    }
    
    // ---------------------------------
    // MARK: - UI
    // ---------------------------------
    
    private var progressLayer: CAShapeLayer = CAShapeLayer()
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        progressLayer.backgroundColor = tintColor.cgColor
    }
    
    // ---------------------------------
    // MARK: - Layout
    // ---------------------------------
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setAppropiateCornerRadius()
        
        
    }
    
    // ---------------------------------
    // MARK: - Other
    // ---------------------------------
    
    private func setAppropiateCornerRadius() {
        var appropiateCornerRadius = min(frame.size.width / 2.0, frame.size.height / 2.0)
        appropiateCornerRadius = min(appropiateCornerRadius, cornerRadius)
        progressLayer.cornerRadius = appropiateCornerRadius
        layer.cornerRadius = appropiateCornerRadius
    }
}

// Interface builder support extension.
extension M13ProgressBar {
    
    @IBInspectable public var _IBprogressDirection: String {
        get {
            switch progressDirection {
            case .leadingToTrailing:
                return "leadingToTrailing"
            case .trailingToLeading:
                return "trailingToLeading"
            case .bottomToTop:
                return "bottomToTop"
            case .topToBottom:
                return "topToBottom"
            }
        }
        set {
            switch newValue {
            case "leadingToTrailing":
                progressDirection = .leadingToTrailing
                break
            case "trailingToLeading":
                progressDirection = .trailingToLeading
                break
            case "bottomToTop":
                progressDirection = .bottomToTop
                break
            case "topToBottom":
                progressDirection = .topToBottom
                break
            default:
                progressDirection = .leadingToTrailing
                break
            }
        }
    }
    
    @IBInspectable public var _IBIndeterminate: Bool {
        get {
            switch type {
            case .determinate:
                return false
            case .indeterminate:
                return true
            }
        }
        set {
            if newValue {
                type = .indeterminate
            } else {
                type = .determinate
            }
        }
    }
    
}
