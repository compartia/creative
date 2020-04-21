 
const BASE = 6;

function color(r, g, b){
    return new Color(r/255.,g/255.,b/255.);
}
const pal = [
  color(193,24,39),
  color(255,227,0),
  color(31,75,149),
  
  color(174,185,184),
  color(239,237,220),
  color(165,213,236),
];


function drawPixel(r, value, bits_pal){

    var th = r * 0.38;
    var angle_deg  = 90 + value * 60 ; 
  
//   rotate(angle);

    var path = new Path();
    path.add(new Point(-th/2, -r/2)); 
    path.add(new Point( th/2, -r/2)); 
    path.add(new Point( th/2, r/2)); 
    path.add(new Point(-th/2, r/2)); 
    path.closed = true;
    path.fillColor =   bits_pal[  (value) % bits_pal.length  ] ;
//   noStroke();
//   fill( bits_pal[  (value) % bits_pal.length  ] );
 
//   endShape(CLOSE);


//   popMatrix();
//   popStyle();
    path.rotate(angle_deg);
    return path;
}

const r_legend = 30;
for (var i=0; i<BASE; i++){
    pixel = drawPixel(r_legend/2, i, pal);  
    pixel.position = new Point(r_legend*(2+i), r_legend*2);
}


var circlePath = new Path.Circle(new Point(280, 100), 25);
circlePath.strokeColor = 'black';
circlePath.fillColor = 'white';

var clones = 30;
var angle = 360 / clones;

for(var i = 0; i < clones; i++) {
	var clonedPath = circlePath.clone();
	clonedPath.rotate(angle * i, circlePath.bounds.topLeft);
};