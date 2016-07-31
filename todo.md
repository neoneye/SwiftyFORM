# Todo list for SwiftyFORM 




# Expand/collapse - Animation glitch at bottom of tableview

Difficulty level: HARD

The code that animates the expand/collapse operation is not perfect.
When tapping a row near the bottom of the tableview, then it may briefly scroll weird.
Simon has made a workaround that scrolls to the right position, but it's clearly visible
that an animation glitch is happening.

The workaround are these functions:

	FormTableView.didExpand_scrollToVisible()
	FormTableView.didCollapse_scrollToVisible()

You can help. If you can get `deleteRowsAtIndexPaths` and `insertRowsAtIndexPaths`
working without exhibiting this animation glitch, then please submit a pull-request.

This happens with SwiftyFORM 0.9.1 on a real iPhone6S running iOS 9.3.2

Actual behavior:

 1. Open the Example app
 2. Go to the "Precision sliders" page
 3. Scroll to the bottom
 4. Expand the bottom-most row
 5. BOOM, here the animation glitch happens

Expected behavior:

 1. Open the Example app
 2. Go to the "Precision sliders" page
 3. Scroll to the bottom
 4. Expand the bottom-most row
 5. A nice insert-animation with the expanded row



# PrecisionSlider - Zoom can be slow

Difficulty level: HARD

During a zoom operation the slider has to reload its collectionview.
The cells are assigned new sizes. Mark-labels are assigned new texts.
If there are too many cells, then the collectionview can be really slow to reload.
At any given time max ~100 cells is visible at any given zoom level.

It's gets noticable when you zoom-in a lot. 
Example: Create a slider that goes from -100k to +100k with 3 decimal places.
Zoom-in 7 times, to the 3 decimal place. Now zooming is slow.

What could be causing this:
 1. Lots of calls to computed variables, such as lengthOfFullItem. 
 2. The collectionview gets way too many cells to keep track of.
 3. The cells are not perfectly pixel-aligned.

Solution:
Precompute the lenghts, see if it impacts performance.
Don't use collectionview/scrollview. Use a custom view, perhaps spritekit based.
