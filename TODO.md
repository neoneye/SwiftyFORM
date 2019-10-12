# Todo list for SwiftyFORM 




# Expand/collapse - Sporadic crashes

Difficulty level: HARD

After moving the code to Xcode8.0 the PrecisionSlider cells have started crashing sporadic.
With Xcode7.3.1 it worked fine.
Tapping random rows so they collapses/expands, sometimes causes a crash.

It happens on the `PrecisionSlidersViewController` page where there are a lot of cells.
Rows in the bottom half are in particular fragile, where the upper cells works ok.

The crash happens in the `ToggleExpandCollapse.execute` function.

Console output

	2016-09-17 20:35:59.543220 Example[2131:582991] *** Assertion failure in -[SwiftyFORM.FormTableView _updateWithItems:updateSupport:], /BuildRoot/Library/Caches/com.apple.xbs/Sources/UIKit/UIKit-3599.6/UITableView.m:3149
	2016-09-17 20:36:17.407424 Example[2131:582991] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Missing cell for newly visible row 16'
	*** First throw call stack:
	(0x18e4341c0 0x18ce6c55c 0x18e434094 0x18eebe82c 0x1945aef78 0x1942b1d78 0x1942c8b84 0x19447b1c0 0x19445f6a4 0x1002d156c 0x10023f4c8 0x10023f67c 0x10023ec60 0x10023fec4 0x100293a18 0x100261a38 0x100261ac8 0x1943aa594 0x19445b050 0x19450e264 0x194500018 0x19426ed6c 0x18e3e17dc 0x18e3df40c 0x18e3df89c 0x18e30e048 0x18fd91198 0x1942e7818 0x1942e2550 0x10006e954 0x18d2f05b8)
	libc++abi.dylib: terminating with uncaught exception of type NSException



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
