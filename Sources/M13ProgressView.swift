//
//  M13ProgressView.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon on 8/7/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

/**
 A standardized base upon which to build progress views for applications. This allows one to use any progress view in any component that use this standard.
 */
public protocol M13ProgressView {
    
    /// A secondary tint color for the progress view.
    var secondaryTintColor: UIColor? { get set }
    
    
}
