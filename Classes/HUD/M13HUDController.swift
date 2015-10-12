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
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
