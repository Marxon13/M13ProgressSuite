//
//  M13HUDController.swift
//  M13ProgressSuite
//
//  Created by Brandon McQuilkin on 10/8/15.
//  Copyright © 2015 Brandon McQuilkin. All rights reserved.
//

import UIKit

/**
The possible positions the status title and message can be in.

- BelowProgress: The text will be below the progress view.
- AboveProgress: The text will be above the progress view.
- LeadingProgress: The text will lead the progress view.
- TrailingProgress: The text will trail the progress view.
*/
public enum M13HUDStatusTextPosition: Int, RawRepresentable {
    /// The text will be below the progress view.
    case BelowProgress
    /// The text will be above the progress view.
    case AboveProgress
    /// The text will lead the progress view.
    case LeadingProgress
    /// The text will trail the progress view.
    case TrailingProgress
}

/**
The pre-defined background styles for the HUD. Pass one of these values on initalization to have the background view set up for you.

- None: Do not add any content to the `backgroundView`.
- SolidColor: Set up the `backgroundView` with a solid color background.
- LightVisualEffectView: Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with `UIBlurEffectStyleLight` as an option.
- ExtraLightVisualEffectView: Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with `UIBlurEffectStyleExtraLight` as an option.
- DarkVisualEffectView: Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with `UIBlurEffectStyleDark` as an option.
- LightVibrantVisualEffectView: Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with a `UIVibrancyEffect` with `UIBlurEffectStyleLight` as an option.
- ExtraLightVibrantVisualEffectView: Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with a `UIVibrancyEffect` with `UIBlurEffectStyleExtraLight` as an option.
- DarkVibrantVisualEffectView: Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with a `UIVibrancyEffect` with `UIBlurEffectStyleDark` as an option.
*/
public enum M13HUDBackgroundStyle: Int, RawRepresentable {
    /// Do not add any content to the `backgroundView`.
    case None
    /// Set up the `backgroundView` with a solid color background.
    case SolidColor
    /// Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with `UIBlurEffectStyleLight` as an option.
    case LightVisualEffectView
    /// Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with `UIBlurEffectStyleExtraLight` as an option.
    case ExtraLightVisualEffectView
    /// Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with `UIBlurEffectStyleDark` as an option.
    case DarkVisualEffectView
    /// Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with a `UIVibrancyEffect` with `UIBlurEffectStyleLight` as an option.
    case LightVibrantVisualEffectView
    /// Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with a `UIVibrancyEffect` with `UIBlurEffectStyleExtraLight` as an option.
    case ExtraLightVibrantVisualEffectView
    /// Set up the `backgroundView` with a `UIVisualEffectView` subview initalized with a `UIVibrancyEffect` with `UIBlurEffectStyleDark` as an option.
    case DarkVibrantVisualEffectView
}

/**
The possible overlay styles of the HUD.

- FullScreen: The HUD extends over the entire screen.
- Rect: The HUD will be a rectangle.
- SquareRect: The HUD will be a square.
- RoundedRect: The HUD will be a rectangle with rounded corners.
- RoundedSquareRect: The HUD will be a square with rounded corners.
*/
public enum M13HUDOverlayStyle: Int, RawRepresentable {
    /// The HUD extends over the entire screen.
    case FullScreen
    /// The HUD will be a rectangle.
    case Rect
    /// The HUD will be a square.
    case SquareRect
    /// The HUD will be a rectangle with rounded corners.
    case RoundedRect
    /// The HUD will be a square with rounded corners.
    case RoundedSquareRect
}

/**
A customizable view controller that presents an HUD. Works similarly to `UIAlertController`.
*/
public class M13HUDController: UIViewController {
    
    //-------------------------------
    // MARK: Appearance
    //-------------------------------
    
    /**
    The position of the title text relative to the progress view.
    */
    public var titlePosition: M13HUDStatusTextPosition = M13HUDStatusTextPosition.AboveProgress
    
    /**
    The position of the message text relative to the progress view.
    */
    public var messagePosition: M13HUDStatusTextPosition = M13HUDStatusTextPosition.BelowProgress
    
    
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The message to the user.
    */
    public var message: String?
    
    /**
    The view that contains the background view and the content view.
    */
    public let containerView: UIView = UIView()
    
    /**
    The view that is the background view. Add any background content to this view.
    */
    public let backgroundView: UIView = UIView()
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    convenience init(backgroundStyle: M13HUDBackgroundStyle) {
        
        self.init(overlayStyle: M13HUDOverlayStyle.RoundedSquareRect, backgroundStyle: backgroundStyle)
    }
    
    convenience init(overlayStyle: M13HUDOverlayStyle) {
        
        self.init(overlayStyle: overlayStyle, backgroundStyle: M13HUDBackgroundStyle.LightVisualEffectView)
    }
    
    convenience init(overlayStyle: M13HUDOverlayStyle, backgroundStyle: M13HUDBackgroundStyle) {
        
        self.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sharedSetup()
    }
    
    private func sharedSetup() {
        // Present over a full screen, as this has the posibility of being semi-transparent.
        modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        // Add the necessary views
        view.addSubview(containerView)
        containerView.addSubview(backgroundView)
        
        var constraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundView]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["backgroundView": backgroundView])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["backgroundView": backgroundView])
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    //-------------------------------
    // MARK: Initalization Presets
    //-------------------------------
    
    private func setupPresetBackground(backgroundStyle: M13HUDBackgroundStyle) {
        switch(backgroundStyle) {
        case .SolidColor:
            backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            break
        case .LightVisualEffectView:
            setupBackgroundViewWithVisualEffectView(UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)))
            break
        case .ExtraLightVisualEffectView:
            setupBackgroundViewWithVisualEffectView(UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)))
            break
        case .DarkVisualEffectView:
            setupBackgroundViewWithVisualEffectView(UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark)))
            break
        case .LightVibrantVisualEffectView:
            setupBackgroundViewWithVisualEffectView(UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: UIBlurEffectStyle.Light))))
            break
        case .ExtraLightVibrantVisualEffectView:
            setupBackgroundViewWithVisualEffectView(UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))))
            break
        case .DarkVibrantVisualEffectView:
            setupBackgroundViewWithVisualEffectView(UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: UIBlurEffectStyle.Dark))))
            break
        case .None:
            // Do nothing
            break
        }
    }
    
    private func setupBackgroundViewWithVisualEffectView(view: UIVisualEffectView) {
        backgroundView.addSubview(view)
        var constraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["view": view])
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["view": view])
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    private func setupConstraintsForOverlayStyle(style: M13HUDOverlayStyle) {
        switch(style) {
        case .FullScreen:
            
            break
        case .Rect:
            
            break
        case .SquareRect:
            
            break
        case .RoundedRect:
            
            break
        case .RoundedSquareRect:
            
            break
        }
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------

    //-------------------------------
    // MARK: Other
    //-------------------------------
}
