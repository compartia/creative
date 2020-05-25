 
<!-- meh -->
<script type="text/javascript" src="https://rawgit.com/patriciogonzalezvivo/glslCanvas/master/dist/GlslCanvas.js"></script>


<style>
    body {
        background: #101515;
    }

    #glslCanvas {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%,-50%);
    }​

    .blank {

    }

    #credits {
        position: absolute; 
        bottom: 10px; 
        right: 15px; 
        text-align: right;
        background: rgba(0,0,0,.5);
        padding: 12px;
        padding-top: 5px;
        padding-bottom: 5px;
        margin: 0px
    }

    .label {
        color: white;
        font-family: Helvetica, Arial, sans-serif;
        text-decoration: none; 
        line-height: 0.0;
    }

    #title {
        font-size: 24px;
        font-weight: 600;
    }

    #author {
        font-size: 14px; 
        font-style: italic;
        font-weight: 100;
    }
</style>

     
<canvas id="glslCanvas" data-fragment="

#ifdef GL_ES
precision mediump float;
#endif


#define HD


#define FAR 23.5
#define TOR_V vec2(1.0, 0.3333)

#ifdef HD
    #define EPS 0.001
    #define STEPS 120
    #define SHAD_STEPS 10
#else
    #define STEPS 60
    #define SHAD_STEPS 0 //must be 30 or so
    #define EPS 0.005
#endif


#define TAU 6.28318530718

#define ROTATION


#define PI 3.14159265359
#define RADIUS 1.// (1.0/(PI*2.0)*PER)
#define mobius_th_speed 5.

#define gamma 2.2

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

vec3 pal_c1 = vec3(1,58,95) / 255.;
vec3 pal_c2 = vec3(131,106,178) /255.;
vec3 pal_c3 = vec3(239,188,119) /255.;
vec3 pal_c4 = vec3(175,58,30) /255.;
vec3 pal_c5 = vec3(0,2,5) /255.;
vec3 pal_c6 = vec3(50,86,96) /255.;
vec3 pal_c7 = vec3(9,29,27) /255.;

float relu(float x){
    return x < 0. ? 0. : x > 1. ? 1. :  x;
}

vec3 gradient(vec3 fc){

    // float blendx = 4. * fc.x + 0.1 * sin(4. * fc.z  + u_time * 15.) ;
    float blendx = 4.5 * fc.x + 0.2 * sin(86. * fc.y  + u_time * 15.) + 0.16 * sin(66. * fc.x + u_time * 5.)  ;

    vec3 rgb = 
          mix( pal_c1, pal_c2, relu(blendx +0.01 ));
    rgb = mix( rgb, pal_c3, relu( -1.3 + blendx  ));
    rgb = mix( rgb, pal_c4, relu( -2. + blendx  ));
    rgb = mix( rgb, pal_c5, relu( -3.1 + blendx  ));
    rgb = mix( rgb, pal_c6, relu( -4.1 + blendx  ));
    rgb = mix( rgb, pal_c7, relu( -5. + blendx  ));
    return rgb;
}

 
float anim_mobius_th(){
    return 0.011 + 0.049 * (2.0 + sin( u_time * mobius_th_speed) + sin( u_time * mobius_th_speed * 0.31498) );
}

float anim_sinesine(float min, float max, float speed){
    return min + (max -min ) * 0.25 * (2.0 + sin( u_time * speed) + sin( u_time * speed * 0.31498) );
}

// tonemapping from https://www.shadertoy.com/view/lslGzl
vec3 filmicToneMapping( vec3 col ) {
    col = max(vec3(0.), col - vec3(0.004));
    return (col * (6.2 * col + .5)) / (col * (6.2 * col + 1.7) + 0.06);
}

vec3 linearToneMapping(vec3 color)
{
	float exposure = 1.;
	color = clamp(exposure * color, 0., 1.);
	color = pow(color, vec3(1. / gamma));
	return color;
}


vec3 RomBinDaHouseToneMapping(vec3 color)
{
    color = exp( -1.0 / ( 2.72*color + 0.15 ) );
	color = pow(color, vec3(1. / gamma));
	return color;
}

float opSubtraction( float d1, float d2 ) { 
    return max(-d1,d2); 
}


float opUnion( float d1, float d2 ) {  
    return min(d1,d2); 
}

float opSmoothSubtraction( float d1, float d2, float k ) {
    float h = clamp( 0.5 - 0.5 * (d2+d1)/k, 0.0, 1.);
    // h = 0.4*sin(0.9*u_time);
    return mix( d2, -d1, h ) + k*h*(1.0-h); 
}

 
float torus(vec3 p) {
  	vec2 q = vec2(length(p.xy) - TOR_V.x, p.z);    
  	return length(q) - TOR_V.y;
}


// iq's functions
float sdBox( in vec3 p, in vec3 b ) {
	vec3 d = abs(p) - b;
	return min(max(d.x,max(d.y,d.z)),0.0) + length(max(d,0.0));
}

// Fabrice's rotation matrix
mat2 rot( in float a ) {
    vec2 v = sin(vec2(PI*0.5, 0) + a);
    return mat2(v, -v.y, v.x);
}

// random/hash function              
float hash( float n ){
  return fract(n * 41415.92653);
}

 

float mobius(vec3 p){
    float th = anim_sinesine(0.02, 0.28, 4.);

    // p=p+0.002 * hash(p.y);

    // cylindrical coordinates
    vec2 cyl = vec2(length(p.xy), p.z);
    float theta = atan(p.x,  p.y);
    vec2 inCyl = vec2(1., 0.) - cyl;
    // rotate 180° to form the loop
    // float _rot = anim_sinesine(0., 2., 1.1);//2.0
    inCyl *= rot( theta * 1.5 );
    // coordinates in a torus (cylindrical coordinates + position on the stripe)
    vec3 inTor = vec3(inCyl, theta * RADIUS);
    
    // add the band
    
    float bandDist = sdBox(inTor, vec3(th, 0.4, 90)) - 0.0001;
    float d = bandDist;

    return d;
}


float map(vec3 p){
    
    float z_wrap = anim_sinesine(0.2, 4., 1.31);

     vec3 rep  = p; 
    float tor = torus(rep);
    float mobius = mobius(rep);
    
    // float d = mobius(p);
    // d=-0.35*sin(d*3.);
    // float dis = 0.0;//displacement(p);
    float smoothh = anim_sinesine(0.001, .1, 3.31); //2.0
    return  opSmoothSubtraction( mobius, tor, smoothh  ); //opSubtraction (  tor , mob) ;
    // return mobius;
}

// non-Cheap shadows 
float softShadow(vec3 ro, vec3 lp, float k){

    
    const int maxIterationsShad = SHAD_STEPS; 
    
    vec3 rd = lp - ro; // Unnormalized direction ray.

    float shade = 1.;
    float dist = .002;    
    float end = max(length(rd), .001);
    float stepDist = end/float(maxIterationsShad);
    
    rd /= end;
 
    // Max shadow iterations - More iterations make nicer shadows, but slow things down. Obviously, the lowest 
    // number to give a decent shadow is the best one to choose. 
    for (int i = 0; i<maxIterationsShad; i++){

        float h = map(ro + rd*dist);
        //shade = min(shade, k*h/dist);
        shade = min(shade, smoothstep(0., 1., k*h/dist)); // Subtle difference. Thanks to IQ for this tidbit.
        // So many options here, and none are perfect: dist += min(h, .2), dist += clamp(h, .01, .2), 
        // clamp(h, .02, stepDist*2.), etc.
        dist += clamp(h, .02, .25);
        
        // Early exits from accumulative distance function calls tend to be a good thing.
        if (h<0. || dist>end) break; 
        //if (h<.001 || dist > end) break; // If you're prepared to put up with more artifacts.
    }

    // I've added 0.5 to the final shade value, which lightens the shadow a bit. It's a preference thing. 
    // Really dark shadows look too brutal to me.
    return min(max(shade, 0.) + .25, 1.); 
}


// Second pass, which is the first, and only, reflected bounce. 
// Virtually the same as above, but with fewer iterations and less 
// accuracy.
//
// The reason for a second, virtually identical equation is that 
// raymarching is usually a pretty expensive exercise, so since the 
// reflected ray doesn't require as much detail, you can relax things 
// a bit - in the hope of speeding things up a little.
float traceRef(vec3 ro, vec3 rd){
    
    float t = 0., d;
    
    for (int i = 0; i < 48; i++){

        d = map(ro + rd*t);        
        if(abs(d)<.002 || t>FAR) break;        
        t += d;
    }
    
    return t;
}

// Standard normal function. It's not as fast as the tetrahedral calculation, but more symmetrical.
vec3 getNormal(in vec3 p) {
	const vec2 e = vec2(.001, 0);
	return normalize(vec3(map(p + e.xyy) - map(p - e.xyy), map(p + e.yxy) - map(p - e.yxy),	map(p + e.yyx) - map(p - e.yyx)));
}

 
mat3 rotY(float ang) {
	float c = cos(ang), s = sin(ang);
	return mat3(c, 0.0, s, 0.0, 1.0, 0.0, -s, 0.0, c);
}

mat3 rotX(float ang) {
	float c = cos(ang), s = sin(ang);
	return mat3(1.0, 0.0, 0.0, 0.0, c, -s, 0.0, s, c);
}

 

// float animCurve(in float t) {
// 	t = mod(u_time, 15.0);
// 	float f1 = smoothstep(5.0, 7.0, t);
// 	float f2 = 1.0-smoothstep(7.0, 9.0, t);
// 	return 0.01+0.09*f1*f2;
// }




// Standard raymarching routine.
float trace(vec3 ro, vec3 rd){   
    float t = 0., d;    
    
    for (int i = 0; i < STEPS; i++){

        d = map(ro + rd*t);
        
        // Using the hacky abs trick, for more accuracy. 
        if(abs(d)<.001 || t>FAR) break;                
        t += d*.75;  // Using more accuracy, in the first pass.
    }
    
    return t;
}

vec3 getObjectColor(vec3 p){   
    
    return gradient( 0.5 +  sin(3.* p * rotY(0.5))*0.5 );
    // return vec3( cos(p.z*13.) + 1.0,  1.3 * torus( sin( p * 3.)),  sin(p.z*12.) + 1.0 );    
}

vec3  doColor(in vec3 sp, in vec3 rd, in vec3 sn, in vec3 lp, float t){
    vec3 ld = lp-sp; // Light direction vector.
    float lDist = max(length(ld), .001); // Light to surface distance.
    ld /= lDist; // Normalizing the light vector.
    
    // Attenuating the light, based on distance.
    float atten = 1. / (1. + lDist*.2 + lDist*lDist*.1);
    
    // Standard diffuse term.
    float diff = max(dot(sn, ld), 0.);

    // Standard specualr term.
    float spec = pow(max( dot( reflect(-ld, sn), -rd ), 0.), 8.);
    
    // Coloring the object. You could set it to a single color, to
    // make things simpler, if you wanted.
    vec3 objCol = getObjectColor(sn);
    
    // Combining the above terms to produce the final scene color.
    vec3 sceneCol = (objCol*(diff + .15) + vec3(1., .6, .2)*spec*2.) * atten;
    
    
    // Fog factor -- based on the distance from the camera.
    float fogF = smoothstep(0., 0.95, t/FAR);
    //
    // Applying the background fog. Just black, in this case, but you could
    // render sky, etc, as well.
    sceneCol = mix(sceneCol, vec3(0), fogF); 

    
    // Return the color. Performed once every pass... of which there are
    // only two, in this particular instance.
    return sceneCol;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 fc = fragCoord.xy / u_resolution.xy;
	vec2 uv = -1.0+2.0*fc;
	uv.x *= u_resolution.x/u_resolution.y;	
	
	vec2 mouse = 0.5*TAU*(-1.0+2.0*u_mouse.xy/u_resolution.xy);
	
	// #ifndef HOMOTOPY
	// 	float b = 0.015;
	// #else
	// 	float b = animCurve(u_time);
	// #endif
	
	#ifdef ROTATION
		mouse.x += 0.3*u_time;
	#endif
	
	mat3 m = rotY(mouse.x) * rotX(mouse.y);

    
    // Ray origin. 
    vec3 ro = m * vec3(0.0, 0.0, 1.7);

    // Light position. Set in the vicinity the ray origin.
    vec3 lp = ro + vec3(0., 1., -.5);
    
    // Unit direction ray.
	vec3 rd = m * normalize(vec3(uv, -1.0));
	
	float d = 10.0, t1 = 0.0;
	vec3 p = ro;
    vec3 col = vec3(1.0);

    // FIRST PASS.
    float t = trace(ro, rd);
    
    // Advancing the ray origin, 'ro,' to the new hit point.
    ro += rd * t;
	
    // Retrieving the normal at the hit point.
    //surface normal
    vec3 sn = getNormal(ro);

    // Retrieving the color at the hit point, which is now 'ro.' Reusing 
    // the ray origin to describe the surface hit point. 
    // Reflective ray will begin from the hit point in the 
    // direction of the reflected ray. Thus the new ray origin will be the hit point. 
    // See 'traceRef' below.
    vec3 sceneColor = doColor(ro, rd, sn, lp, t);

    float sh = 0.01;
    
    #ifdef HD
        sh = 0.1;
        // sh = softShadow(ro +  sn*.0015, lp, 16.);
    #endif
    
    // SECOND PASS - REFLECTED RAY
    
    // Standard reflected ray, which is just a reflection of the unit
    // direction ray off of the intersected surface. You use the normal
    // at the surface point to do that. Hopefully, it's common sense.
    rd = reflect(rd, sn);

     // The reflected pass begins where the first ray ended, which is the suface
    // hit point, or in a few cases, beyond the far plane. By the way, for the sake
    // of simplicity, we'll perform a reflective pass for non hit points too. Kind
    // of wasteful, but not really noticeable. The direction of the new ray will
    // obviously be in the direction of the reflected ray. See just above.
    //
    // To anyone who's new to this, don't forgot to nudge the ray off of the 
    // initial surface point. Otherwise, you'll intersect with the surface
    // you've just hit. After years of doing this, I still forget on occasion.
    t = traceRef(ro +  sn*.003, rd);
    
    // Advancing the ray origin, 'ro,' to the new reflected hit point.
    ro += rd*t;
    
    // Retrieving the normal at the reflected hit point.
    sn = getNormal(ro);

    // Coloring the reflected hit point, then adding a portion of it to the final scene color.
    // How much you add, and how you apply it is up to you, but I'm simply adding 35 percent.
    sceneColor += doColor(ro, rd, sn, lp, t) * 0.35 + 0.1 * sh;
    // Other combinations... depending what you're trying to achieve.
    //sceneColor = sceneColor*.7 + doColor(ro, rd, sn, lp, t)*.5;

    // Clamping the scene color, performing some rough gamma correction (the 'sqrt' bit), then 
    // presenting it to the screen.
    sceneColor = RomBinDaHouseToneMapping(0.6*sceneColor);
	fragColor =   vec4(clamp(sceneColor, 0., 1.), 1);
    
}

void main() {        
  mainImage(gl_FragColor, gl_FragCoord.xy);
}


" width="800" height="600"></canvas>

      
   

<script>
    var canvas = document.getElementById("glslCanvas");
    var sandbox = new GlslCanvas(canvas);
    var texCounter = 0;
    var sandbox_content = "";
    var sandbox_title = "";
    var sandbox_author = "";
    var sandbox_thumbnail = ""; 
    canvas.style.width = '100%';
    canvas.style.height = '100%';

    sandbox.setUniform("u_brightness",1.5); 

</script>
  
 