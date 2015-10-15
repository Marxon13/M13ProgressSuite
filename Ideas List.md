New Progress Views
==================

Gradient Progress Views
-----------------------
A gradient along the direction of progress. 

- Option to show 100% of the gradient range, or cut off the gradient to only the visible progress percentage. (If that makes any sense.)
- Add as a subclass of each progress view class?

Bordered Segmented Progress Views
---------------------------------
Bordered segmented progress views (Each segment has its own outline)

Size Based Segmented Progress Views
-----------------------------------
Size based segmented progress view that increases the size of the segments as progress increases.

Image Sequence
--------------
Maps progress information to images in an array.

- Accepts an array of UIImages for determinate, indeterminate, animating between determinate and indeterminate, success (and animating to/from), and failure (and animating to/from.)
- Accepts gif file paths?
- Accepts asset image sequence name?
- Accepts an array of arrays of UIImages, such that each progress amount is also animated?

Custom Path Progress "Bar"
------------------------
Takes a custom path and animates the stroke of the path to denote progress.

- Possibly animate between paths for different states.

Liquid
------
Fills a shape with liquid

- Add dynamics based on device tilt?

Text
----
Animates text to show progress.

- Fill
- Stroke
- Size?

Features
--------

- Switch the primary color to a function that could change the primary color based on the percentage completed? By default it would just return the tint color.
- Add more states like "warning", "error"