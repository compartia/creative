
const BASE = 6;

function color(r, g, b) {
    return new Color(r / 255.0, g / 255.0, b / 255.0);
}
const pal = [
    color(193, 24, 39),
    color(255, 227, 0),
    color(31, 75, 149),

    color(174, 185, 184),
    color(239, 237, 220),
    color(165, 213, 236),
];


function drawPixel(r, value, bits_pal) {

    var th = r * 0.38;
    var angle_deg = 90 + value * 60;

    //   rotate(angle);

    var path = new Path();
    path.add(new Point(-th / 2, -r / 2));
    path.add(new Point(th / 2, -r / 2));
    path.add(new Point(th / 2, r / 2));
    path.add(new Point(-th / 2, r / 2));
    path.closed = true;
    path.fillColor = bits_pal[(value) % bits_pal.length];
    //   noStroke();
    //   fill( bits_pal[  (value) % bits_pal.length  ] );

    //   endShape(CLOSE);


    //   popMatrix();
    //   popStyle();
    path.rotate(angle_deg);
    return path;
}

const r_legend = 30;
for (var i = 0; i < BASE; i++) {
    pixel = drawPixel(r_legend / 2, i, pal);
    pixel.position = new Point(r_legend * (2 + i), r_legend * 2);
}

const hex_aspect = Math.sin(2.0 * Math.PI / 3.0);

const _digits = [1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0]
const R = 200;

function drawSectorHalf(digits, bits_pal) {
    const rd = R / 15.0;

    var n = 0;
    var group = new Group();

    for (var row = 0; row < 30; row++) {
        for (var j = row / 2; j < row; j++) {
            if (n < digits.length) {

                const ci = digits[n]; //digit corresponds to color and rotation 

                // following the grid
                var x = rd + j * rd - rd * (row % 2) * 0.5 - rd * Math.ceil(row / 2);
                var y = hex_aspect * (row * rd);


                pixel = drawPixel(rd, ci, bits_pal, false);
                pixel.position = new Point(x, y);
                group.addChild(pixel)

            }
            n++;
        }

    }


    sector = new SymbolDefinition(group, true);

    return sector;

}

sector = drawSectorHalf(_digits, pal)
center = view.size / 2;
for (var i = 0; i < 12; i++) {
    instance = sector.place();
    if (i % 2 == 0) {
        instance.scale(-1, 1)
    }
    instance.pivot = new Point(0, 0);
    instance.rotate(30 * i - 30 * (i % 2));
    instance.position = center;

}