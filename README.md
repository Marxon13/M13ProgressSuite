<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/M13ProgressSuiteBanner.png">

2.0.0
=====

The 2.0.0 update is coming! Now that I have some time, I'll be updating M13ProgressSuite to Swift. Along with the conversion, I'll be making some updates under the hood to make M13ProgressSuite more reliable. Interface Builder support is also on its way. Even though I have time to do this update, I don't have unlimited time to work on the library. So all fixes and feature requests that are not pull requests will be added to version 2.0.0. I've published the base project, as all that needs to happen now is converting the individual progress views to swift. If anyone wants to lend a hand that would be greatly appreciated.

Thanks,
Brandon

TODO
====

**Repo**
- Update readme to include small gifs.
- Add .io site for complete example list and property examples, with images of what property changes will do.
- Add generated documentation to .io site.
- Add CI service.
- Add direction and ideas list to .io site.

**Overall**
- Support NSCoding protocol on all classes.
- Support NSCopying protocol on all classes.
- Add animations and transitions for all possible visual changes that would be user-visible.
- Move icon generation into own class. Pass draw rect for icon, size of icon. Make it easier to override with custom icons. 
- New icons that fit iOS 7+ style.
- Add optional animation completion blocks to setState and setProgress.
- Possibly move some requirements from M13ProgressView class / subclasses to protocols. Like some shared requirements for the segmented progress views.
- Add wrapper to display percentage outside of progress view: leading, trailing, above, below.

**Examples**
- Fix crash when phone is in portrait mode.
- Make layouts of all examples vertically scrollable.
- Include controls to change all parameters except for color.
- Make layouts dynamic. No controls should overlap.
- Add app extension example.
- Research and Add watch OS example. (After everything else is done)

**Ring**
- Add stroke animation for x and "check" when shown, fade when hide.
- Add boolean to set the bar background color to the tint color instead of secondary.
- Multistage animation for indeterminate transition.
    - Decrease width of progress bar.
    - Animate in the gap in the progress background.
    - Start rotating the progress background.
    - When finished, complete a revolution before closing the gap.

**Navigation Bar**
- Custom height of progress bar.
- Custom progress bar offset.
- Prefix all methods with "m13_" to avoid conflicts.

**Segmented Progress Views**
- Add support for an array of primary colors.

**Console**
- Remove? Not up to par with the rest of the controls. Can't see use case for it.

**Filtered Image**
- Pre-render images? Provide hook for ΔProgress to render images for? Therefore fixing issues with lag.

**Image**
- Rename to greyscale image.

**Pie**
- Better indeterminate animation.
- Hide progress once finished when switching to non-normal state.

**HUD**
- Add option of buttons to allow cancelation of current activity.

M13ProgressSuite
================

A collection of easy to use progress views for iOS applications. The collection includes progress views of many types (bar, ring, etc.), an UINavigationBar with progress bar, and a HUD overlay. Everything in the collection is easily styled through code or Interface Builder, and is simple to update. 

Checkout the [M13ProgressSuite website](marxon13.github.io/M13ProgressSuite) to see more examples and documentation.

Features:
---------
* All progress views inherit from the same base class, making it easy to use multiple kinds of progress views in a project, or swap kinds of progress views.
* The progress views have a determinate state, indeterminate state, success state, and failure state.
* All the progress views are IBDesignable.
* It is very easy to make custom progress views, as the base class handles the grunt work of the animation. Just write the code to display a specific progress value, as well as the indeterminate, success and failure states.

Contact Me:
-------------
If you have any questions comments or suggestions, send me a message. If you find a bug, or want to submit a pull request, let me know.

License:
--------
MIT License

> Copyright (c) 2015 Brandon McQuilkin
> 
> Permission is hereby granted, free of charge, to any person obtaining 
>a copy of this software and associated documentation files (the  
>"Software"), to deal in the Software without restriction, including 
>without limitation the rights to use, copy, modify, merge, publish, 
>distribute, sublicense, and/or sell copies of the Software, and to 
>permit persons to whom the Software is furnished to do so, subject to  
>the following conditions:
> 
> The above copyright notice and this permission notice shall be 
>included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
>IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
>CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
>TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
>SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
