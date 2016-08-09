//
//  M13ProgressViewBase.swift
//  M13ProgressSuite
//
//  Created by McQuilkin, Brandon (NonEmp) on 8/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

@IBDesignable
public class M13ProgressViewBase: UIView, M13ProgressView {
    
    // ---------------------------------
    // MARK: - Initalization
    // ---------------------------------
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        secondaryTintColor = aDecoder.decodeObject(forKey: "secondaryTintColor") as? UIColor
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(secondaryTintColor, forKey: "secondaryTintColor")
    }
    
    /**
     The setup shared between the various initalizers.
    */
    internal func sharedSetup() {
    
    }
    
    // ---------------------------------
    // MARK: - Properties
    // ---------------------------------
    
    @IBInspectable public var secondaryTintColor: UIColor?
    
    
}
