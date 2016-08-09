//
//  M13ProgressIndeterminate.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 8/7/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

/**
 The possible types of progress the progress views can display.
 
 - **determinate**: The amount of progress made or the time remaining is known.
 - **indeterminate**: The amount of progress and the remaining time is unknown.
 */
public enum M13ProgressType {
    /// The amount of progress made or the time remaining is known.
    case determinate
    /// The amount of progress and the remaining time is unknown.
    case indeterminate
}

/**
 A protocol that provides the structure for determinate progress views.
*/
public protocol M13ProgressViewDeterminate {
    
    /**
     The progress displayed to the user as a percentage from 0.0 to 1.0.
    */
    var progress: CGFloat { get set }
    
    /**
     Set the progress of the progress view, with the option of animating the change.
     - parameter progress: The amount of progress that has been made.
     - parameter animated: Whether or no to animate the change.
     - parameter completion: The completion block to run once the animation has finished.
     */
    func setProgress(_ progress: CGFloat, animated: Bool, completion: ((progress: CGFloat) -> Void)?)
    
    /**
     The animation duration for determinate progress animations.
    */
    var determinateProgressAnimationDuration: TimeInterval { get set }
}

/**
 A protocol that provides the structure for indeterminate progress views.
*/
public protocol M13ProgressViewIndeterminate {
    
    /**
     The animation duration for indeterminate progress animations.
    */
    var indeterminateProgressAnimationDuration: TimeInterval { get set }
}

/**
 A protocol that provides structure for progress views that can show both determinate and indeterminate progress.
 */
public protocol M13ProgressViewMultipleType: M13ProgressViewDeterminate, M13ProgressViewIndeterminate {
    
    /**
     The type of progress the progress view is displaying.
    */
    var type: M13ProgressType { get set }
    
    /**
     Set the type of progress the progress view is displaying, with the option of animating the change.
     - parameter type: The new type of the progress the progress view will display.
     - parameter animated: Whether or no to animate the change.
     - parameter completion: The completion block to run once the animation has finished.
     */
    func setType(_ type: M13ProgressType, animated: Bool, completion: ((type: M13ProgressType) -> Void)?)
}

