//
//  M13ProgressState.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 8/7/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

/**
The possible states of progress views.
 
 - **normal**: The progress view is in its normal state of displaying progress.
 - **success**: The progress view displays an indicator that the operation completed successfully.
 - **failure**: The progress view displays an indicator that the operation failed.
*/
public enum M13ProgressState {
    /// The progress view is in its normal state of displaying progress.
    case progressing
    /// The progress view displays an indicator that the operation completed successfully.
    case success
    /// The progress view displays an indicator that the operation failed.
    case failure
}

/**
 A protocol that provides structure for progress views that have success and failure states.
*/
public protocol M13ProgressViewState {
    
    /**
    The current state of the progress view.
    */
    var state: M13ProgressState { get set }
    
    /**
     Set the state of the progress view, with the option of animating the state change.
     - parameter state: The new state of the progress view.
     - parameter animated: Whether or no to animate the change.
     - parameter completion: The completion block to run once the animation has finsihed.
    */
    func setState(_ state: M13ProgressState, animated: Bool, completion: ((state: M13ProgressState) -> Void)?)
    
}
