int N = 140;
ArrayList < float[] > data;
void setup() {
    size(640, 640);
    background(0);
    frameRate(30);
    smooth(4);
    pixelDensity(2);//retina
    background(0);

    data = prepareData(N, 190);
}



void draw(){
    background(0);

    float dx = ((float)width) /N;
    float dy = ((float)height) / data.size();

    //translate(dx/2, dy/2);

    println(dy);
    float y = 0;
    for (int n = data.size() - 1; n >= 0; n--) {
        y = dy * n;
        float[] line = data.get(n);
        float x = 0;

        beginShape();
        vertex(0, 0);
        vertex(0, y + line[0]);
        for (int i = 0; i < line.length; i++) {

            fill(255);
            noStroke();
            vertex(x, y + line[i]);
            x += dx;

        }

        vertex(dx * line.length, y + line[line.length - 1]);
        vertex(dx * line.length, 0);

    
        noFill();
        stroke(255, 200);
        strokeWeight(dy / 3.);
        endShape();

    }

 
    noLoop();
}

float[] copyarr(float[] a){
    float[] arr = new float[a.length];
    for (int i = 0; i < a.length; i++) {
        arr[i] = a[i];
    }
    return arr;
}

ArrayList < float[] > prepareData(int nx, int ny){
    float[] prev_line = makeLineArr(nx);
    ArrayList < float[] > lines = new ArrayList();
    for (int y = 0; y < ny; y++) {
        float[] line = copyarr(prev_line);
        for (int i = 0; i < y; i++) {
            jamLine(line, nx / 2, 1.8);
        }
        lines.add(line);
        prev_line = line;
    }

    return lines;
}

void jamLine(float[] arr, int softness, float amplitude){

    int segments = arr.length;
    int rndi = (int)random(segments); //random index to add distortion

    int start = max(0, rndi - softness);
    int end = min(segments, rndi + softness);
    float off = amplitude / 2 - random(1) * amplitude;
    for (int i = start; i < end; i++) {
        float magnitude = 1.0 / (1 + abs(i - rndi));
        arr[i] += magnitude * off;
    }
}

float[] makeLineArr(int segments){
    float[] arr = new float[segments];
    for (int i = 0; i < segments; i++) {
        arr[i] = 0;
    }

    return arr;
}


void mouseReleased() {
    println(frameCount + " ");
    saveFrame("/Users/artem/work/creative-code/opart_13_hex/opart__####.png");
}
