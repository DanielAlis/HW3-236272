# Dry Exercise

1) We are using the snapping sheet controller class to implement the controller pattern in this library.
with the snapping sheet controller, you can control the sheet in multiple ways - change its position,
stop current snapping and etc. In addition, you can also extract information from the sheet - the current snapping position and etc.

2) The parameter which controls this kind of behavior is the snapping Curve. 
With the snapping curve, you can control which animation is going to be used when snapping.

3) GestureDetector advantage over the former is that GestureDetector provides more controls like dragging. 
on the other hand, one advantage of InkWell over the latter is that Inkwell includes ripple effect tap, 
which is more responsive for the user while GestureDetector doesn’t.
