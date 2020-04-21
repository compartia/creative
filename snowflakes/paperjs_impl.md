<!-- meh -->
<script src='https://cdnjs.cloudflare.com/ajax/libs/paper.js/0.12.2/paper-full.min.js'></script>

<canvas id="myCanvas" resize></canvas>

 

# Appendix 2: JS encoding implementation

<script type="text/javascript">
window.onload = function() {
	paper.setup('myCanvas');
	with (paper) {
		var path = new Path();
		path.strokeColor = 'black';
		var start = new Point(100, 100);
		path.moveTo(start);
		path.lineTo(start.add([ 200, -50 ]));
		view.draw();
	}
}
</script>
