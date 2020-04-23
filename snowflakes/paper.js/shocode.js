
const BASE = 6;
const LEGEND = 1;
const hex_aspect = Math.sin(2.0 * Math.PI / 3.0);

const R = 400;
const rd = R / 15.0;


function color(r, g, b) {
    return new Color(r / 255.0, g / 255.0, b / 255.0);
}
const pal = [
    'rgba(0,0,0)',
    color(193, 24, 39),
    color(255, 227, 0),
    color(31, 75, 149),

    color(174, 185, 184),
    color(239, 237, 220),
    color(165, 213, 236),
];


function drawPixel(r, value, bits_pal) {
    // r/=hex_aspect;
    var th = r * 0.35;
    var angle_deg = 30 + value * 60;

    var sign = value == 3 || value == 4 ? 1 : -1;
    const skew = 0;//0.5*th/hex_aspect;// * sign;

    var path = new Path();
    path.add(new Point(-th / 2, -r / 2));
    path.add(new Point(th / 2, -r / 2 + skew));
    path.add(new Point(th / 2, r / 2 + skew));
    path.add(new Point(-th / 2, r / 2));
    path.closed = true;

    var hex = drawHex(0, 0, r / hex_aspect / 2);
    hex.fillColor = path.fillColor = {
        gradient: {
            stops: [bits_pal[(value + 1) % bits_pal.length], 
            bits_pal[(value) % bits_pal.length]]
        },
        origin: [0, -r / 2],
        destination: [0, r / 2]
    }
    path.fillColor = bits_pal[(value + 1) % bits_pal.length];


    hex.rotate(angle_deg);
    path.rotate(120 + angle_deg);
    return new Group([hex, path]);//Group([path, hex]);
}

if (LEGEND) {
    const r_legend = 30;
    for (var i = 0; i < BASE; i++) {
        pixel = drawPixel(r_legend / 2, i, pal);
        pixel.position = new Point(r_legend * (2 + i), r_legend * 2);
    }
}


const _digits = [1, 2, 3, 4, 0, 1, 2, 3, 4, 5, 0, 0, 3, 1, 2, 0, 3, 4, 5, 0, 1, 2, 0, 3, 4, 5, 0, 1, 2, 3, 4, 5, 0]

function drawSectorHalf(digits, bits_pal) {


    var n = 0;
    var group = new Group(
        //     new Path.Circle({
        //     center: [0, 0],
        //     radius: 2,
        //     fillColor: 'red'
        // })
    );

    for (var row = 0; row < 30; row++) {
        for (var j = row / 2; j < row; j++) {
            if (n < digits.length) {

                const ci = digits[n]; //digit corresponds to color and rotation 

                // following the grid
                var x = rd + (j) * rd - rd * (row % 2) * 0.5 - Math.ceil(rd * row / 2);
                var y = hex_aspect * ((row + 2) * rd);


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


function drawHex(x, y, d) {
    var path = new Path();
    for (var i = 0; i < 6; i++) {
        var angle = i * Math.PI / 3.0;
        _p = new Point(d * Math.cos(angle), d * Math.sin(angle));
        path.add(_p);
    }
    path.closed = true;
    return path;
}