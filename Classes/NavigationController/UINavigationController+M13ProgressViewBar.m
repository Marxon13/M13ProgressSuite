//
//  UINavigationController+M13ProgressViewBar.m
//  M13ProgressView
//

#import "UINavigationController+M13ProgressViewBar.h"
#import <objc/runtime.h>

//Keys to set properties since one cannot define properties in a category.
static char oldTitleKey;
static char displayLinkKey;
static char animationFromKey;
static char animationToKey;
static char animationStartTimeKey;
static char progressKey;
static char progressViewKey;
static char indeterminateKey;
static char indeterminateLayerKey;
static char isShowingProgressKey;
static char primaryColorKey;
static char secondaryColorKey;

@implementation UINavigationController (M13ProgressViewBar)

#pragma mark Title

- (void)setProgressTitle:(NSString *)title
{
    //Change the title on screen.
    NSString *oldTitle = [self getOldTitle];
    if (oldTitle == nil) {
        //We haven't changed the navigation bar yet. So store the original before changing it.
        [self setOldTitle:self.visibleViewController.navigationItem.title];
    }
    
    if (title != nil) {
        self.visibleViewController.navigationItem.title = title;
    } else {
        self.visibleViewController.navigationItem.title = oldTitle;
        [self setOldTitle:nil];
    }
}

#pragma mark Progress

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    CADisplayLink *displayLink = [self getDisplayLink];
    if (animated == NO) {
        if (displayLink) {
            //Kill running animations
            [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [self setDisplayLink:nil];
        }
        [self setProgress:progress];
    } else {
        [self setAnimationStartTime:CACurrentMediaTime()];
        [self setAnimationFromValue:[self getProgress]];
        [self setAnimationToValue:progress];
        if (!displayLink) {
            //Create and setup the display link
            [displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateProgress:)];
            [self setDisplayLink:displayLink];
            [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        } /*else {
           //Reuse the current display link
           }*/
    }
}

- (void)animateProgress:(CADisplayLink *)displayLink
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat dt = (displayLink.timestamp - [self getAnimationStartTime]) / [self getAnimationDuration];
        if (dt >= 1.0) {
            //Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an animation in progress and try to stop it by itself. Once over one, set to actual progress amount. Animation is over.
            [displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            [self setDisplayLink:nil];
            [self setProgress:[self getAnimationToValue]];
            return;
        }
        
        //Set progress
        [self setProgress:[self getAnimationFromValue] + dt * ([self getAnimationToValue] - [self getAnimationFromValue])];
        
    });
}

- (void)finishProgress
{
    UIView *progressView = [self getProgressView];

    if (progressView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                CGRect progressFrame = progressView.frame;
                progressFrame.size.width = self.navigationBar.frame.size.width;
                progressView.frame = progressFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    progressView.alpha = 0;
                } completion:^(BOOL finished) {
                    [progressView removeFromSuperview];
                    progressView.alpha = 1;
                    [self setTitle:nil];
                    [self setIsShowingProgressBar:NO];
                }];
            }];
        });
    }
}

- (void)cancelProgress
{
    UIView *progressView = [self getProgressView];
    
    if (progressView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                progressView.alpha = 0;
            } completion:^(BOOL finished) {
                [progressView removeFromSuperview];
                progressView.alpha = 1;
                [self setTitle:nil];
                [self setIsShowingProgressBar:NO];
            }];
        });
    }
}

#pragma mark Drawing

- (void)showProgress
{
    UIView *progressView = [self getProgressView];
    
    [UIView animateWithDuration:.1 animations:^{
        progressView.alpha = 1;
    }];
    
    [self setIsShowingProgressBar:YES];
}

- (void)updateProgress
{
    [self updateProgressWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)updateProgressWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //Create the progress view if it doesn't exist
	UIView *progressView = [self getProgressView];
    if(!progressView)
	{
		progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2.5)];
		progressView.backgroundColor = self.navigationBar.tintColor;
        if ([self getPrimaryColor]) {
            progressView.backgroundColor = [self getPrimaryColor];
        }
        progressView.clipsToBounds = YES;
        [self setProgressView:progressView];
	}
    
    //Calculate the frame of the navigation bar, based off the orientation.
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    //Calculate the width of the screen
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        //Use the maximum value
        width = MAX(screenSize.width, screenSize.height);
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            height = 32.0; //Hate hardcoding values, but autolayout doesn't work, and cant retreive the new height until after the animation completes.
        } else {
            height = 44.0; //Hate hardcoding values, but autolayout doesn't work, and cant retreive the new height until after the animation completes.
        }
    } else {
        //Use the minimum value
        width = MIN(screenSize.width, screenSize.height);
        height = 44.0; //Hate hardcoding values, but autolayout doesn't work, and cant retreive the new height until after the animation completes.
    }
    
    //Check if the progress view is in its superview and if we are showing the bar.
    if (progressView.superview == nil && [self isShowingProgressBar]) {
        [self.navigationBar addSubview:progressView];
    }
    
    //Layout
    if (![self getIndeterminate]) {
        //Calculate the width of the progress view;
        float progressWidth = width * [self getProgress];
        //Set the frame of the progress view
        progressView.frame = CGRectMake(0, height - 2.5, progressWidth, 2.5);
    } else {
        //Calculate the width of the progress view
        progressView.frame = CGRectMake(0, height - 2.5, width, 2.5);
    }
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateProgressWithInterfaceOrientation:toInterfaceOrientation];
    [self drawIndeterminateWithInterfaceOrientation:toInterfaceOrientation];
}

- (void)drawIndeterminate
{
    [self drawIndeterminateWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)drawIndeterminateWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([self getIndeterminate]) {
        //Get the indeterminate layer
        CALayer *indeterminateLayer = [self getIndeterminateLayer];
        if (!indeterminateLayer) {
            //Create if needed
            indeterminateLayer = [CALayer layer];
            [self setIndeterminateLayer:indeterminateLayer];
        }
        
        //Calculate the frame of the navigation bar, based off the orientation.
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        //Calculate the width of the screen
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            //Use the maximum value
            width = MAX(screenSize.width, screenSize.height);
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                height = 32.0; //Hate hardcoding values, but autolayout doesn't work, and cant retreive the new height until after the animation completes.
            } else {
                height = 44.0; //Hate hardcoding values, but autolayout doesn't work, and cant retreive the new height until after the animation completes.
            }
        } else {
            //Use the minimum value
            width = MIN(screenSize.width, screenSize.height);
            height = 44.0; //Hate hardcoding values, but autolayout doesn't work, and cant retreive the new height until after the animation completes.
        }
        
        //Create the pattern image
        CGFloat stripeWidth = 2.5;
        //Start the image context
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(stripeWidth * 4.0, stripeWidth * 4.0), NO, [UIScreen mainScreen].scale);
        //Fill the background
        if ([self getPrimaryColor]) {
            [[self getPrimaryColor] setFill];
        } else {
        [self.navigationBar.tintColor setFill];
        }
        UIBezierPath *fillPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, stripeWidth * 4.0, stripeWidth * 4.0)];
        [fillPath fill];
        //Draw the stripes
        //Set the stripe color
        if ([self getSecondaryColor]) {
            [[self getSecondaryColor] setFill];
        } else {
            CGFloat red;
            CGFloat green;
            CGFloat blue;
            CGFloat alpha;
            [self.navigationBar.barTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
            //System set the tint color to a close to, but not non-zero value for each component. 
            if (alpha > .05) {
                [self.navigationBar.barTintColor setFill];
            } else {
                [[UIColor whiteColor] setFill];
            }
            
        }
        
        for (int i = 0; i < 4; i++) {
            //Create the four inital points of the fill shape
            CGPoint bottomLeft = CGPointMake(-(stripeWidth * 4.0), stripeWidth * 4.0);
            CGPoint topLeft = CGPointMake(0, 0);
            CGPoint topRight = CGPointMake(stripeWidth, 0);
            CGPoint bottomRight = CGPointMake(-(stripeWidth * 4.0) + stripeWidth, stripeWidth * 4.0);
            //Shift all four points as needed to draw all four stripes
            bottomLeft.x += i * (2 * stripeWidth);
            topLeft.x += i * (2 * stripeWidth);
            topRight.x += i * (2 * stripeWidth);
            bottomRight.x += i * (2 * stripeWidth);
            //Create the fill path
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:bottomLeft];
            [path addLineToPoint:topLeft];
            [path addLineToPoint:topRight];
            [path addLineToPoint:bottomRight];
            [path closePath];
            [path fill];
        }
        //Retreive the image
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //Set the background of the progress layer
        indeterminateLayer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
        
        //remove any indeterminate layer animations
        [indeterminateLayer removeAllAnimations];
        //Set the indeterminate layer frame and add to the sub view
        indeterminateLayer.frame = CGRectMake(0, 0, width + (4 * 2.5), 2.5);
        UIView *progressView = [self getProgressView];
        [progressView.layer addSublayer:indeterminateLayer];
        //Add the animation
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.duration = .1;
        animation.repeatCount = HUGE_VALF;
        animation.removedOnCompletion = YES;
        animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(- (2 * 2.5) + (width / 2.0), 2.5 / 2.0)];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0 + (width / 2.0), 2.5 / 2.0)];
        [indeterminateLayer addAnimation:animation forKey:@"position"];
    } else {
        CALayer *indeterminateLayer = [self getIndeterminateLayer];
        [indeterminateLayer removeAllAnimations];
        [indeterminateLayer removeFromSuperlayer];
    }
}

#pragma mark properties

- (void)setOldTitle:(NSString *)oldTitle
{
    objc_setAssociatedObject(self, &oldTitleKey, self.visibleViewController.navigationItem.title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)getOldTitle
{
    return objc_getAssociatedObject(self, &oldTitleKey);
}

- (void)setDisplayLink:(CADisplayLink *)displayLink
{
    objc_setAssociatedObject(self, &displayLinkKey, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CADisplayLink *)getDisplayLink
{
    return objc_getAssociatedObject(self, &displayLinkKey);
}

- (void)setAnimationFromValue:(CGFloat)animationFromValue
{
    objc_setAssociatedObject(self, &animationFromKey, [NSNumber numberWithFloat:animationFromValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)getAnimationFromValue
{
    NSNumber *number = objc_getAssociatedObject(self, &animationFromKey);
    return number.floatValue;
}

- (void)setAnimationToValue:(CGFloat)animationToValue
{
    objc_setAssociatedObject(self, &animationToKey, [NSNumber numberWithFloat:animationToValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)getAnimationToValue
{
    NSNumber *number = objc_getAssociatedObject(self, &animationToKey);
    return number.floatValue;
}

- (void)setAnimationStartTime:(NSTimeInterval)animationStartTime
{
    objc_setAssociatedObject(self, &animationStartTimeKey, [NSNumber numberWithFloat:animationStartTime], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)getAnimationStartTime
{
    NSNumber *number =  objc_getAssociatedObject(self, &animationStartTimeKey);
    return number.floatValue;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress > 1.0) {
        progress = 1.0;
    } else if (progress < 0.0) {
        progress = 0.0;
    }
    objc_setAssociatedObject(self, &progressKey, [NSNumber numberWithFloat:progress], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //Draw the update
    if ([NSThread isMainThread]) {
        [self updateProgress];
    } else {
        //Sometimes UINavigationController runs in a background thread. And drawing is not thread safe.
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress];
        });
    }
}

- (void)setIsShowingProgressBar:(BOOL)isShowingProgressBar
{
    objc_setAssociatedObject(self, &isShowingProgressKey, [NSNumber numberWithBool:isShowingProgressBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)getProgress
{
    NSNumber *number =  objc_getAssociatedObject(self, &progressKey);
    return number.floatValue;
}

- (CGFloat)getAnimationDuration
{
    return .3;
}

- (void)setProgressView:(UIView *)view
{
    objc_setAssociatedObject(self, &progressViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)getProgressView
{
    return objc_getAssociatedObject(self, &progressViewKey);
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    objc_setAssociatedObject(self, &indeterminateKey, [NSNumber numberWithBool:indeterminate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateProgress];
    [self drawIndeterminate];
}

- (BOOL)getIndeterminate
{
    NSNumber *number = objc_getAssociatedObject(self, &indeterminateKey);
    return number.boolValue;
}

- (void)setIndeterminateLayer:(CALayer *)indeterminateLayer
{
    objc_setAssociatedObject(self, &indeterminateLayerKey, indeterminateLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)getIndeterminateLayer
{
    return objc_getAssociatedObject(self, &indeterminateLayerKey);
}

- (BOOL)isShowingProgressBar
{
    return [objc_getAssociatedObject(self, &isShowingProgressKey) boolValue];
}

- (void)setPrimaryColor:(UIColor *)primaryColor
{
    objc_setAssociatedObject(self, &primaryColorKey, primaryColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self getProgressView].backgroundColor = primaryColor;
    [self setIndeterminate:[self getIndeterminate]];
}

- (UIColor *)getPrimaryColor
{
    return objc_getAssociatedObject(self, &primaryColorKey);
}

- (void)setSecondaryColor:(UIColor *)secondaryColor
{
    objc_setAssociatedObject(self, &secondaryColorKey, secondaryColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setIndeterminate:[self getIndeterminate]];
}

- (UIColor *)getSecondaryColor
{
    return objc_getAssociatedObject(self, &secondaryColorKey);
}

@end
