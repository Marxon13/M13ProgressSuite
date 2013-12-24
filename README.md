M13ProgressSuite
================

A set of classes used to display progress information to users on iOS.

Includes:
---------
* A interchangeable set of progress view of diffrent styles. All the progress views are based on the same superclass, allowing any of them to be switched with any other easily.
* A progress bar for UINavigationBar that works like Apple's Messages app. It also has the added feature of having an indeterminate style.
* A HUD overlay that works over any UIView. Uses the M13ProgressView class to allow easy customizablility of the progress view.
* A progress view that is styled like terminal.
* Complete documentation of each class.

UINavigationController (M13ProgressViewBar)
---------------------
Adds a progress bar to the UINavigationController's UINavigationBar. The progress bar is controlled through the UINavigationController. 

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/NavigationBar.png)

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/NavigationBarIndeterminate.png)

M13ProgressHUD
---------------
A customizable HUD that displays progress, and status information to the user. It uses the M13ProgressView class to allow easy changing of the progress view style.

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/M13ProgressHUD.png)

M13ProgressConsole
------------------
A progress view styled like Terminal on OS X.

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/M13ProgressConsole.png)

M13ProgressViews
----------------
A set of progess view based off of the same superclass. Allowing easy switching between progress view. Each progress view has success and failure actions, an indeterminate mode, and appearance customization features.

**Ring**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/Ring.png)

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/RingIndeterminate.png)

**Segmented Ring**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/SegmentedRing.png)

**Pie**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/Pie.png)

**Bar**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/Bar.png)

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/BarIndeterminate.png)

**Segmented Bar**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/SegmentedBar.png)

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/SegmentedBarIndeterminate.png)

**Bordered Bar**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/BorderedBar.png)

**Striped Bar**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/StripedBar.png)

**Image**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/Image.png)

**Filtered Image**

![image](https://raw.github.com/Marxon13/M13ProgressSuite/master/Images/FilteredImage.png)

Known Bugs:
------------
* When the HUD is set to apply the iOS 7 style blur to the HUD background, it doesn't work. The screenshot of the superview is not taken in the proper CGRect. It seems to work when the mask type is set to iOS 7 Blur, I beleive it is because the CGRectOrigin is {0, 0}.

Contact Me:
-------------
If you have any questions comments or suggestions, send me a message. If you find a bug, or want to submit a pull request, let me know.

License:
--------
MIT License

> Copyright (c) 2013 Brandon McQuilkin
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
