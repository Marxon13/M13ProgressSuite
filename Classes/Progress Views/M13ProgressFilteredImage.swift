//
//  M13ProgressFilteredImage.swift
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
The possible filters that can be applied to a progress image.

- Blur: The image goes from blurry to in-focus as progress nears completion.
- LightTunnel:
- SepiaTone: The image goes from Sepia Tone to full-color as progress nears completion.
*/
public enum M13ProgressImageProgressFilter: Int, RawRepresentable {
    ///
    case Blur
    ///
    case LightTunnel
    ///
    case SepiaTone
    
}

/**
A progress view where progress is shown by changes in CIFilters.
@note This progress bar does not have in indeterminate mode and does not respond to actions.
*/
@IBDesignable
public class M13ProgressFilteredImage: M13ProgressView {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The direction the progress bar travels in as the progress nears completion. (What direction the fill proceeds in.)
    */
    @IBInspectable public var progressFilter: M13ProgressImageProgressFilter = .Blur {
        didSet {
            switch (progressFilter) {
            case .Blur:
                setBlurFilter()
            case .LightTunnel:
                setLightTunnelFilter()
            case .SepiaTone:
                setSepiaToneFilter()
            }
            progressUpdate?()
        }
    }
    
    /**
    The image to use when showing progress.
    */
    @IBInspectable public var progressImage: UIImage! {
        didSet {
            progressUpdate?()
        }
    }
    
    //-------------------------------
    // MARK: Filter Variables
    //-------------------------------

    /**
    The array of CIFilters to apply to the image.
    */
    public var filters :[AnyObject] = []
    
    /**
    The dictionaries of dictionaries that correspond to filter properties to be changed.
    NSArray
    |------ NSDictionary (Index matches the coresponding CIFilter in filters)
    |               |---- "Parameter Key" -> NSDictionary
    |               |                               |------ "Start Value" -> NSNumber
    |               |                               |------ "End Value" -> NSNumber
    |               |---- "Parameter Key" -> NSDictionary
    |                                               |------ "Start Value" -> NSNumber
    |                                               |------ "End Value" -> NSNumber
    |------ NSDictionary ...
    */
    public var filterParameters :[ [String:AnyObject] ] = []
    
    /**
    Keys for the filterParameters dictionary.
    */
    public let FilterStartValuesKey = "StartValues"
    public let FilterEndValuesKey   = "EndValues"
    
    //-------------------------------
    // MARK: Protected Variables
    //-------------------------------
    
    /**
    The UIImageView that shows the progress image.
    */
    internal var progressView: UIImageView!
    
    /**
    Link to the display to keep animations in sync.
    */
    internal var displayLink: CADisplayLink!
    
    //-------------------------------
    // MARK: Initalization
    //-------------------------------
    
    override public init() {
        super.init()
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValueForKey("progressFilter") {
            if let filter = M13ProgressImageProgressFilter(rawValue: aDecoder.decodeIntegerForKey("progressFilter")) {
                progressFilter = filter
            }
        }
        if aDecoder.containsValueForKey("progressImage") {
            if let img = aDecoder.decodeObjectForKey("progressImage") as? UIImage {
                progressImage = img
            }
        }
        
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    internal func sharedSetup() {
        // Set the defaults
        self.clipsToBounds = false
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        // Set the progress image view
        progressView = UIImageView(frame: self.bounds)
        progressView.contentMode = .ScaleAspectFit
        addSubview(progressView)
        
        // Layout
        layoutSubviews()
        
        // Set the progress animation.
        weak var weakSelf: M13ProgressFilteredImage? = self
        progressUpdate = {() -> Void in
            if let retainedSelf = weakSelf {
                retainedSelf.progressView.image = retainedSelf.createImageForCurrentProgress()
            }
        }
        
        // There is no indeterminate animation.
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(progressFilter.rawValue, forKey: "progressFilter")
        aCoder.encodeObject(progressImage)
        super.encodeWithCoder(aCoder)
    }
    
    public override func prepareForInterfaceBuilder() {
        sharedSetup()
        super.prepareForInterfaceBuilder()
    }
    
    //-------------------------------
    // MARK: Filters
    //-------------------------------
    
    internal func setBlurFilter()
    {
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            return
        }
        
        blurFilter.setDefaults()
        
        filters = [ blurFilter ]
        
        filterParameters = [
            [
                "inputRadius" : [
                    FilterStartValuesKey : CGFloat(100.0),
                    FilterEndValuesKey   : CGFloat(0.0)
                ]
            ]
        ]
    }
    
    internal func setSepiaToneFilter()
    {
        guard let sepiaFilter = CIFilter(name: "CISepiaTone") else {
            return
        }

        sepiaFilter.setDefaults()
        
        // Set filter intensity
        sepiaFilter.setValue(1.0, forKey: kCIInputIntensityKey)
        
        filters = [ sepiaFilter ]
        
        filterParameters = [
            [
                kCIInputIntensityKey : [
                    FilterStartValuesKey : CGFloat(1.0),
                    FilterEndValuesKey   : CGFloat(0.0)
                ]
            ]
        ]
    }
    
    internal func setLightTunnelFilter()
    {
        if false { "TODO: CILightTunnel filter does not work yet" }
        
        guard let lightTunnelFilter = CIFilter(name: "CILightTunnel") else {
            return
        }

        lightTunnelFilter.setDefaults()

        // Get center
        let center = CIVector(CGPoint: CGPointMake(progressImage.size.width / 2.0, progressImage.size.height / 2.0))
        lightTunnelFilter.setValue(center, forKey: "inputCenter")

        filters = [ lightTunnelFilter ]
        
        filterParameters = [
            [
                "inputRotation" : [
                    FilterStartValuesKey : CGFloat(10.0),
                    FilterEndValuesKey   : CGFloat(0.0)
                ],
                "inputRadius" : [
                    FilterStartValuesKey : CGFloat(20.0),
                    FilterEndValuesKey   : CGFloat(0.0)
                ]
            ]
        ]
    }
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric)
    }
    
    //-------------------------------
    // MARK: Draw Functions
    //-------------------------------
    
    public func createImageForCurrentProgress() -> UIImage? {
        guard let cgimage = progressImage.CGImage else {
            return nil
        }
        
        // Create the base CIImage
        var ciimage = CIImage(CGImage: cgimage)
        // Change the values of the CIFilters before drawing
        for (var i = 0; i < filters.count; ++i) {
            let filter = filters[i]
            // For each filter
            let parameters = filterParameters[i]
            // For each parameter
            for parameterKey in parameters.keys {
                // Retrieve the values
                let obj = parameters[parameterKey]
                if let parameterDict = obj as? [String:CGFloat] {
                    if let startValue = parameterDict[FilterStartValuesKey], let endValue = parameterDict[FilterEndValuesKey] {
                        // Calculate the current value
                        let value = startValue + ((endValue - startValue) * self.progress)
                        // Set the value
                        filter.setValue(value, forKey: parameterKey)
                    }
                }
            }
            // Set the input image
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            if let img0 = filter.outputImage, let img1 = img0 {
                ciimage = img1
            }
        }
        return UIImage(CIImage: ciimage)
    }
    
}
