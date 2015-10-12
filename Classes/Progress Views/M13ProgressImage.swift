//
//  M13ProgressImage.swift
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
A progress bar where progress is shown by cutting an image.
@note This progress bar does not have in indeterminate mode and does not respond to actions.
*/
@IBDesignable
public class M13ProgressImage: M13ProgressView {
    
    //-------------------------------
    // MARK: Properties
    //-------------------------------
    
    /**
    The direction the progress bar travels in as the progress nears completion. (What direction the fill proceeds in.)
    */
    @IBInspectable public var progressDirection: M13ProgressBarProgressDirection = .LeadingToTrailing {
        didSet {
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
    
    /** 
    Whether or not to draw the greyscale background. 
    */
    @IBInspectable public var drawGreyscaleBackground: Bool = true {
        didSet {
            progressUpdate?()
        }
    }
    
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
        if aDecoder.containsValueForKey("progressDirection") {
            if let direction = M13ProgressBarProgressDirection(rawValue: aDecoder.decodeIntegerForKey("progressDirection")) {
                progressDirection = direction
            }
        }
        if aDecoder.containsValueForKey("progressImage") {
            if let img = aDecoder.decodeObjectForKey("progressImage") as? UIImage {
                progressImage = img
            }
        }
        if aDecoder.containsValueForKey("drawGreyscaleBackground") {
            drawGreyscaleBackground = aDecoder.decodeBoolForKey("drawGreyscaleBackground")
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
        weak var weakSelf: M13ProgressImage? = self
        progressUpdate = {() -> Void in
            if let retainedSelf = weakSelf {
                retainedSelf.progressView.image = retainedSelf.createImageForCurrentProgress()
            }
        }
        
        // There is no indeterminate animation.
    }
    
    public override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(progressDirection.rawValue, forKey: "progressDirection")
        aCoder.encodeObject(progressImage, forKey: "progressImage")
        aCoder.encodeBool(drawGreyscaleBackground, forKey: "drawGreyscaleBackground")
        super.encodeWithCoder(aCoder)
    }
    
    public override func prepareForInterfaceBuilder() {
        sharedSetup()
        super.prepareForInterfaceBuilder()
    }
    
    //-------------------------------
    // MARK: Actions
    //-------------------------------
    
    //-------------------------------
    // MARK: Layout
    //-------------------------------
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric)
    }
    
    //-------------------------------
    // MARK: Draw Functions
    //-------------------------------
    
    public func createImageForCurrentProgress() -> UIImage?
    {
        // Create image rectangle with current image width/height
        let imageRect = CGRectMake(0, 0, progressImage.size.width * progressImage.scale, progressImage.size.height * progressImage.scale)
        
        let width  = imageRect.size.width
        let height = imageRect.size.height
        
        // The pixels will be painted to this array
        let BPP = 4  // 4 bytes per pixel (alpha-red-green-blue)
        let memsize = Int(width) * Int(height)
        let pixels = UnsafeMutablePointer<UInt32>.alloc(memsize)
        // Clear the pixels so any transparency is preserved
        pixels.initializeFrom(Repeat(count: memsize, repeatedValue: 0))
        
        //Create a context with ARGB pixels
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue
        let context = CGBitmapContextCreate(pixels, Int(width), Int(height), 8, Int(width) * BPP, colorSpace, bitmapInfo)
        
        // Paint the bitmap to our context which will fill in the pixels array
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), progressImage.CGImage)
        
        // Calculate the ranges to make greyscale or transparent
        var xFrom: Int = 0
        var xTo  : Int = Int(width)
        var yFrom: Int = 0
        var yTo  : Int = Int(height)
        
        if (progressDirection == .BottomToTop) {
            yTo = Int(height * (1 - self.progress))
        } else if (progressDirection == .TopToBottom) {
            yFrom = Int(height * self.progress)
        } else if (progressDirection == .LeadingToTrailing) {
            xFrom = Int(width * self.progress)
        } else if (progressDirection == .TrailingToLeading) {
            xTo = Int(width * (1 - self.progress))
        }
        
        for (var x = xFrom; x < xTo; ++x) {
            for (var y = yFrom; y < yTo; ++y) {
                // Get the pixel
                let index = (y * Int(width) + x)
                // Convert
                if drawGreyscaleBackground {
                    
                    let value = pixels[index]
                    
                    // Mask out the alpha component
                    let alpha = value & 0x000000FF
                    
                    // Mask out the red-green-blue component values, and bitshift them down to one byte
                    let r0 = UInt8((value & 0x0000FF00) >>  8)
                    let g0 = UInt8((value & 0x00FF0000) >> 16)
                    let b0 = UInt8((value & 0xFF000000) >> 24)
                    
                    if false { "TODO: grayscale has a very green hue to it -- should be more gray" }
                    
                    // Convert each red-green-blue component value to grayscale using luma coding
                    // http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                    let r1 = UInt8(0.299 * CGFloat(r0))
                    let g1 = UInt8(0.587 * CGFloat(g0))
                    let b1 = UInt8(0.114 * CGFloat(b0))
                    
                    // Set the current pixel to gray
                    // Bitshift the red-green-blue component values left so we can OR them into a 4-byte pixel value
                    let r2 = UInt32(r1) <<  8
                    let g2 = UInt32(g1) << 16
                    let b2 = UInt32(b1) << 24
                    pixels[index] = alpha | r2 | g2 | b2
                } else {
                    // Convert the current pixel to transparent
                    pixels[index] = 0
                }
            }
        }
        
        // We're done with the pixel array, so release it
        pixels.dealloc(memsize)
        
        // Create a new CGImageRef from our context with the modified pixels, then
        // Make a new UIImage to return
        if let image = CGBitmapContextCreateImage(context) {
            return UIImage(CGImage: image, scale: progressImage.scale, orientation: .Up)
        }
        
        return nil
    }
    
}
