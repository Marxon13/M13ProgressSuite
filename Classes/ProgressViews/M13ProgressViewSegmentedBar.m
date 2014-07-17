//
//  M13ProgressViewSegmentedBar.m
//  M13ProgressView
//
/*Copyright (c) 2013 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13ProgressViewSegmentedBar.h"

@interface M13ProgressViewSegmentedBar ()

/**The start progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationFromValue;
/**The end progress for the progress animation.*/
@property (nonatomic, assign) CGFloat animationToValue;
/**The start time interval for the animaiton.*/
@property (nonatomic, assign) CFTimeInterval animationStartTime;
/**Link to the display to keep animations in sync.*/
@property (nonatomic, strong) CADisplayLink *displayLink;
/**Allow us to write to the progress.*/
@property (nonatomic, readwrite) CGFloat progress;
/**The layer that progress is shown on.*/
@property (nonatomic, retain) CAShapeLayer *progressLayer;
/**The layer that the background shown on.*/
@property (nonatomic, retain) CAShapeLayer *backgroundLayer;
/**The action currently being performed.*/
@property (nonatomic, assign) M13ProgressViewAction currentAction;

@end

@implementation M13ProgressViewSegmentedBar
{
    NSInteger indeterminateIndex;
    NSTimer *indeterminateTimer;
}

@dynamic progress;

#pragma mark Initalization and setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Set own background color
    self.backgroundColor = [UIColor clearColor];
    
    //Set defauts
    self.animationDuration = .3;
    _progressDirection = M13ProgressViewSegmentedBarProgressDirectionLeftToRight;
    _numberOfSegments = 16;
    _segmentSeparation = 10.0;
    _cornerRadius = 2.0;
    
    //Set default colors
    self.primaryColor = [UIColor colorWithRed:0 green:122/255.0 blue:1.0 alpha:1.0];
    self.secondaryColor = [UIColor colorWithRed:181/255.0 green:182/255.0 blue:183/255.0 alpha:1.0];
    _successColor = [UIColor colorWithRed:63.0f/255.0f green:226.0f/255.0f blue:80.0f/255.0f alpha:1];
    _failureColor = [UIColor colorWithRed:249.0f/255.0f green:37.0f/255.0f blue:0 alpha:1];
    
    //ProgressLayer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = self.primaryColor.CGColor;
    _progressLayer.frame = self.bounds;
    [self.layer addSublayer:_progressLayer];
    
    //Backround
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.fillColor = self.secondaryColor.CGColor;
    _backgroundLayer.frame = self.bounds;
    [self.layer addSublayer:_backgroundLayer];
    
    //Layout
    [self layoutSubviews];
}

#pragma mark Appearance

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    [super setPrimaryColor:primaryColor];
    _progressLayer.fillColor = self.primaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    [super setSecondaryColor:secondaryColor];
    _backgroundLayer.fillColor = self.secondaryColor.CGColor;
    [self setNeedsDisplay];
}

- (void)setSuccessColor:(UIColor *)successColor
{
    _successColor = successColor;
    [self setNeedsDisplay];
}

- (void)setFailureColor:(UIColor *)failureColor
{
    _failureColor = failureColor;
    [self setNeedsDisplay];
}

- (void)setProgressDirection:(M13ProgressViewSegmentedBarProgressDirection)progressDirection
{
    _progressDirection = progressDirection;
    [self layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setNumberOfSegments:(NSInteger)numberOfSegments
{
    _numberOfSegments = numberOfSegments;
    [self setNeedsDisplay];
}

- (void)setSegmentSeparation:(CGFloat)segmentSeparation
{
    _segmentSeparation = segmentSeparation;
    [self setNeedsDisplay];
}

- (void)setSegmentShape:(M13ProgressViewSegmentedBarSegmentShape)segmentShape
{
    _segmentShape = segmentShape;
    [self setNeedsDisplay];
}

#pragma mark Actions

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (animated == NO) {
        if (_displayLink) {
            //Kill running animations
            [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            _displayLink = nil;
        }
        [super setProgress:progress animated:NO];
        [self setNeedsDisplay];
    } else {
        _animationStartTime = CACurrentMediaTime();
        _animationFromValue = self.progress;
        _animationToValue = progress;
        if (!_displayLink) {
            //Create and setup the display link
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        } /*else {
           //Reuse the current display link
           }*/
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - _animationStartTime) / self.animationDuration;
        if (dt >= 1.0) {
            //Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
            [super setProgress:_animationToValue animated:NO];
            [self setNeedsDisplay];
            return;
        }
        
        //Set progress
        [super setProgress:_animationFromValue + dt * (_animationToValue - _animationFromValue) animated:YES];
        [self setNeedsDisplay];
        
    });
}

- (void)performAction:(M13ProgressViewAction)action animated:(BOOL)animated
{
    if (action == M13ProgressViewActionNone && _currentAction != M13ProgressViewActionNone) {
        _currentAction = action;
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.fillColor;
        barAnimation.toValue = (id)self.primaryColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"fillColor"];
        [CATransaction commit];
    } else if (action == M13ProgressViewActionSuccess && _currentAction != M13ProgressViewActionSuccess) {
        _currentAction = action;
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.fillColor;
        barAnimation.toValue = (id)_successColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"fillColor"];
        [CATransaction commit];
    } else if (action == M13ProgressViewActionFailure && _currentAction != M13ProgressViewActionFailure) {
        _currentAction = action;
        [self setNeedsDisplay];
        [CATransaction begin];
        CABasicAnimation *barAnimation = [self barColorAnimation];
        barAnimation.fromValue = (id)_progressLayer.fillColor;
        barAnimation.toValue = (id)_failureColor.CGColor;
        [_progressLayer addAnimation:barAnimation forKey:@"fillColor"];
        [CATransaction commit];
    }
}

- (CABasicAnimation *)barColorAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animation.duration = 2 * self.animationDuration;
    animation.repeatCount = 1;
    //Prevent the animation from resetting
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    [super setIndeterminate:indeterminate];
    
    if (indeterminate) {
        indeterminateTimer = [NSTimer timerWithTimeInterval:(1.5 / (float)_numberOfSegments) target:self selector:@selector(drawIndeterminate) userInfo:Nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:indeterminateTimer forMode:NSRunLoopCommonModes];
    } else {
        [indeterminateTimer invalidate];
        [self setNeedsDisplay];
    }
}

#pragma mark Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _progressLayer.frame = self.bounds;
    _backgroundLayer.frame = self.bounds;

}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
}

#pragma mark Drawing

- (NSInteger)numberOfFullSegments
{
    return (NSInteger)floorf(self.progress * _numberOfSegments);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!self.indeterminate) {
        [self drawProgress];
        [self drawBackground];
    }
}

- (void)drawProgress
{
    //Calculate the segment width (totalWidth - totalSeparationwidth / numberOfSegments
    CGFloat segmentWidth = 0;
    if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewSegmentedBarProgressDirectionRightToLeft) {
        segmentWidth = (self.bounds.size.width - ((_numberOfSegments - 1) * _segmentSeparation)) / _numberOfSegments;
    } else {
        segmentWidth = (self.bounds.size.height - ((_numberOfSegments - 1) * _segmentSeparation)) / _numberOfSegments;
    }
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
        cornerRadius = _cornerRadius;
    } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
        cornerRadius = floorf(self.bounds.size.height < segmentWidth ? self.bounds.size.height / 2.0 : segmentWidth / 2.0);
    }
    //Create the path ref that all the paths will be appended
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //Iterate through all the segments that are full.
    for (int i = 0; i < [self numberOfFullSegments]; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        //Move to top left of rectangle
        if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionLeftToRight) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), (self.bounds.size.height - (2 * cornerRadius)) / 2, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionRightToLeft) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, (self.bounds.size.height - (2 * cornerRadius)) / 2, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionBottomToTop) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(0, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(0, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake((self.bounds.size.width - (2 * cornerRadius)) / 2, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionTopToBottom) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(0, (i * (segmentWidth + _segmentSeparation)), self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(0, (i * (segmentWidth + _segmentSeparation)), self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake((self.bounds.size.width - (2 * cornerRadius)) / 2, (i * (segmentWidth + _segmentSeparation)), 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
        }
        
        //Add the segment to the path
        CGPathAddPath(pathRef, NULL, path.CGPath);
    }
    //Set the paths to the layer
    _progressLayer.path = pathRef;

    CGPathRelease(pathRef);
}

- (void)drawBackground
{
    //Calculate the segment width (totalWidth - totalSeparationwidth / numberOfSegments
    CGFloat segmentWidth = 0;
    if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewSegmentedBarProgressDirectionRightToLeft) {
        segmentWidth = (self.bounds.size.width - ((_numberOfSegments - 1) * _segmentSeparation)) / _numberOfSegments;
    } else {
        segmentWidth = (self.bounds.size.height - ((_numberOfSegments - 1) * _segmentSeparation)) / _numberOfSegments;
    }
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
        cornerRadius = _cornerRadius;
    } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
        cornerRadius = floorf(self.bounds.size.height < segmentWidth ? self.bounds.size.height / 2.0 : segmentWidth / 2.0);
    }
    //Create the path ref that all the paths will be appended
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    //Iterate through all the segments that are full.
    for (int i = 0; i < _numberOfSegments - [self numberOfFullSegments]; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        //Move to top left of rectangle
        if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionRightToLeft) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle || _segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), (self.bounds.size.height - (2 * cornerRadius)) / 2, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionLeftToRight) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, (self.bounds.size.height - (2 * cornerRadius)) / 2, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionTopToBottom) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(0, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(0, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake((self.bounds.size.width - (2 * cornerRadius)) / 2, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionBottomToTop) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(0, (i * (segmentWidth + _segmentSeparation)), self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(0, (i * (segmentWidth + _segmentSeparation)), self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake((self.bounds.size.width - (2 * cornerRadius)) / 2, (i * (segmentWidth + _segmentSeparation)), 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
        }
        
        //Add the segment to the path
        CGPathAddPath(pathRef, NULL, path.CGPath);
    }
    //Set the paths to the layer
    _backgroundLayer.path = pathRef;

    CGPathRelease(pathRef);
}

- (void)drawIndeterminate
{
    //Calculate the segment width (totalWidth - totalSeparationwidth / numberOfSegments
    CGFloat segmentWidth = 0;
    if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionLeftToRight || _progressDirection == M13ProgressViewSegmentedBarProgressDirectionRightToLeft) {
        segmentWidth = (self.bounds.size.width - ((_numberOfSegments - 1) * _segmentSeparation)) / _numberOfSegments;
    } else {
        segmentWidth = (self.bounds.size.height - ((_numberOfSegments - 1) * _segmentSeparation)) / _numberOfSegments;
    }
    //Calculate the corner radius
    CGFloat cornerRadius = 0;
    if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
        cornerRadius = _cornerRadius;
    } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
        cornerRadius = floorf(self.bounds.size.height < segmentWidth ? self.bounds.size.height / 2.0 : segmentWidth / 2.0);
    }
    //What index will the segments be colored from.
    NSInteger numberOfSegmentsToBeColored = _numberOfSegments / 4;
    //Create the path ref that all the paths will be appended
    CGMutablePathRef progressPathRef = CGPathCreateMutable();
    CGMutablePathRef backgroundPathRef = CGPathCreateMutable();
    
    //Iterate through all the segments that are full.
    for (int i = 0; i < _numberOfSegments; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        //Move to top left of rectangle
        if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionLeftToRight) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake(i * (segmentWidth + _segmentSeparation), (self.bounds.size.height - (2 * cornerRadius)) / 2, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionRightToLeft) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 0, segmentWidth, self.bounds.size.height);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake(self.bounds.size.width - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, (self.bounds.size.height - (2 * cornerRadius)) / 2, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionBottomToTop) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(0, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(0, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake((self.bounds.size.width - (2 * cornerRadius)) / 2, self.bounds.size.height - (i * (segmentWidth + _segmentSeparation)) - segmentWidth, 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
            
        } else if (_progressDirection == M13ProgressViewSegmentedBarProgressDirectionTopToBottom) {
            if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRectangle) {
                CGRect rect = CGRectMake(0, (i * (segmentWidth + _segmentSeparation)), self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRect:rect];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeRoundedRect) {
                CGRect rect = CGRectMake(0, (i * (segmentWidth + _segmentSeparation)), self.bounds.size.width, segmentWidth);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            } else if (_segmentShape == M13ProgressViewSegmentedBarSegmentShapeCircle) {
                CGRect rect = CGRectMake((self.bounds.size.width - (2 * cornerRadius)) / 2, (i * (segmentWidth + _segmentSeparation)), 2 * cornerRadius, 2 * cornerRadius);
                path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
            }
        }
        
        //Add the segment to the proper path
        if (i >= indeterminateIndex && i < indeterminateIndex + numberOfSegmentsToBeColored) {
            CGPathAddPath(progressPathRef, NULL, path.CGPath);
        } else {
            CGPathAddPath(backgroundPathRef, NULL, path.CGPath);
        }
        
    }
    //Set the paths to the layer
    _progressLayer.path = progressPathRef;
    _backgroundLayer.path = backgroundPathRef;

    CGPathRelease(progressPathRef);
    CGPathRelease(backgroundPathRef);

    //increase the index by one for movement
    indeterminateIndex += 1;
    if (indeterminateIndex == numberOfSegmentsToBeColored + _numberOfSegments) {
        indeterminateIndex = -numberOfSegmentsToBeColored;
    }
}

@end
