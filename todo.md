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



