#ifdef GL_ES
precision mediump float;
#endif

#define FAR 20.5
#define EPS 0.01
#define STEPS 150
#define TAU 6.28318530718

#define ROTATION

// perimeter of the moebius strip is 38
#define PI 3.14159265359
// #define PER 2.
#define RADIUS 1.// (1.0/(PI*2.0)*PER)


// #define HOMOTOPY

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float opSubtraction( float d1, float d2 ) { 
    return max(-d1,d2); 
}

float opUnion( float d1, float d2 ) {  
    return min(d1,d2); 
}

//trus distancefield
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz) - t.x, p.y);
  return length(q) - t.y;
}

float torus(vec3 p) {
	vec2 t = vec2(1.0, 0.3333);
    // return sdTorus(p, t);
    float l = length(p.xy);
    // l = l + .1 * cos( .3 * l + 1.*u_time) ;
  	vec2 q = vec2(l - t.x, p.z);
  	return length(q) - t.y;
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

float mob(vec3 p){
    

    // cylindrical coordinates
    vec2 cyl = vec2(length(p.xy), p.z);
    float theta = atan(p.x, p.y);
    vec2 inCyl = vec2(1., 0) - cyl;
    // rotate 180° to form the loop
    inCyl *= rot(theta * 1.5-2.0);
    // coordinates in a torus (cylindrical coordinates + position on the stripe)
    vec3 inTor = vec3(inCyl, theta * RADIUS);
    
    // add the band
    float bandDist = sdBox(inTor, vec3(0.1, 0.5, 100)) - 0.0001;
    float d = bandDist;

    return d;
}

float mobius(vec3 p, float b) {
    
    
    float ROT = 3.0;
	float x = p.x, y = p.y, z = p.z;
	float xx = x*x, yy = y*y, zz = z*z, y3 = yy*y, x3 = xx*x;
	float xy = xx+yy, b2 = b * 2.0;
    
    float zxy = z*(xx*y*ROT - y3);
    float xyy = x*yy*ROT - x3;

    // float C = 0.2;
    float k1 = (2.0*zxy+xyy*(xy-zz+1.0))*(b-0.1) - xy * xy * ( b2 + 0.2 );
    float k2 = b * xy * 0.2 + (b2-0.2) * (zxy+xyy) - xy* (b+0.1) * (xy+zz+1.0);
	// return  min(-(k1*k1-xy*k2*k2) , -trus);

    return   k1 * k1 + xy * k2 * k2;
     
}

float opSmoothSubtraction( float d1, float d2, float k ) {
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return mix( d2, -d1, h ) + k*h*(1.0-h); 
}


float map(vec3 p){
    // float link = sdLink(p, 1., 0.4, 0.2);
    float tor = torus(p);
    float mob = mob(p);
    // return mobius(p, 0.015);
    // return tor;//opSubtraction (tor, link);
     
    return opSmoothSubtraction(mob, tor, 0.015  );//opSubtraction (  tor , mob) ;
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

float circleshape(vec2 position, float radius){
	return step(radius, length(position - vec2(0.5)));
}






vec3 grad(vec3 p, float b) {
	vec2 q = vec2(0.0, EPS);
	return vec3(mobius(p+q.yxx, b) - mobius(p-q.yxx, b), 
			    mobius(p+q.xyx, b) - mobius(p-q.xyx, b),
			    mobius(p+q.xxy, b) - mobius(p-q.xxy, b));
}



mat3 rotY(float ang) {
	float c = cos(ang), s = sin(ang);
	return mat3(c, 0.0, s, 0.0, 1.0, 0.0, -s, 0.0, c);
}

mat3 rotX(float ang) {
	float c = cos(ang), s = sin(ang);
	return mat3(1.0, 0.0, 0.0, 0.0, c, -s, 0.0, s, c);
}

vec3 shade(vec3 p, vec3 rd, float b, mat3 m) {
	vec3 col = vec3(0.0);
	vec3 n = normalize(-grad(p, b));
	
	// material
	vec3  amb = vec3(0.05375, 0.05, 0.06625);
	vec3  dif = vec3(0.18275, 0.17, 0.22525);
	vec3  spe = vec3(0.332741, 0.328634, 0.346435);
	float shin = 39.4;
	
	// key light
	vec3 l = normalize(m*vec3(1.0));
	vec3 h = normalize(l-rd);
	float lambert = max(0.0, dot(n, l));
	float blinn = lambert > 0.0 ? pow(max(0.0, dot(n, h)), shin) : 0.0;
	col += vec3(3.0, 2.0, 3.0)*(0.4*dif*lambert + 1.4*spe*blinn + 0.1*amb);
	
	// fill light
	lambert = max(0.0, dot(n, -rd));
	blinn = lambert > 0.0 ? pow(lambert, shin) : 0.0;
	col += vec3(1.0)*(0.4*dif*lambert + 1.4*spe*blinn + 0.1*amb);
	
	// rim light
	// col += 2.25*pow(clamp(1.0+dot(n, rd), 0.0, 1.0), 3.0); 
    col += 2.25*pow(clamp(1.0+dot(n, rd), 0.0, 1.0), 3.0); 
	
	return col/(col+1.0); // reinhard
}

float animCurve(in float t) {
	t = mod(u_time, 15.0);
	float f1 = smoothstep(5.0, 7.0, t);
	float f2 = 1.0-smoothstep(7.0, 9.0, t);
	return 0.01+0.09*f1*f2;
}




// Standard raymarching routine.
float trace(vec3 ro, vec3 rd){   
    float t = 0., d;    
    
    for (int i = 0; i < STEPS; i++){

        d = map(ro + rd*t);
        
        // Using the hacky "abs," trick, for more accuracy. 
        if(abs(d)<.001 || t>FAR) break;                
        t += d*.75;  // Using more accuracy, in the first pass.
    }
    
    return t;
}

vec3 getObjectColor(vec3 p){
   
    // return torus(p)
    // float timek = (0.6 + 0.5 * sin (u_time*5.));
    return vec3(0.3, 2.7*torus( sin(p*2.)),  1.0 ) ;
    
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
    vec3 objCol = getObjectColor(sp);
    
    // Combining the above terms to produce the final scene color.
    vec3 sceneCol = (objCol*(diff + .15) + vec3(1., .6, .2)*spec*2.) * atten;
    
    
    // Fog factor -- based on the distance from the camera.
    float fogF = smoothstep(0., .95, t/FAR);
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
	
	#ifndef HOMOTOPY
		float b = 0.015;
	#else
		float b = animCurve(u_time);
	#endif
	
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
    
    // Advancing the ray origin, "ro," to the new hit point.
    ro += rd * t;
	
    // Retrieving the normal at the hit point.
    //surface normal
    vec3 sn = getNormal(ro);

    // Retrieving the color at the hit point, which is now "ro." Reusing 
    // the ray origin to describe the surface hit point. 
    // Reflective ray will begin from the hit point in the 
    // direction of the reflected ray. Thus the new ray origin will be the hit point. 
    // See "traceRef" below.
    vec3 sceneColor = doColor(ro, rd, sn, lp, t);

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
    
    // Advancing the ray origin, "ro," to the new reflected hit point.
    ro += rd*t;
    
    // Retrieving the normal at the reflected hit point.
    sn = getNormal(ro);

    // Coloring the reflected hit point, then adding a portion of it to the final scene color.
    // How much you add, and how you apply it is up to you, but I'm simply adding 35 percent.
    sceneColor += doColor(ro, rd, sn, lp, t) * 0.35;
    // Other combinations... depending what you're trying to achieve.
    //sceneColor = sceneColor*.7 + doColor(ro, rd, sn, lp, t)*.5;


    // Clamping the scene color, performing some rough gamma correction (the "sqrt" bit), then 
    // presenting it to the screen.
	fragColor = vec4(sqrt(clamp(sceneColor, 0., 1.)), 1);

	// // sphere-trace to torus envelope.
	// for (int i = 0; i < STEPS; ++i) {
	// 	if (d < EPS || t1 > 4.0) continue;
	// 	d = torus(p);
	// 	t1 += d; 
    //     p = ro + t1*rd;
	// }
	
	// if (d < EPS) {	
	// 	// forward march to find root interval.
	// 	float t2 = t1; d = mobius(p, b);
	// 	for (int i = 0; i < 2*STEPS; ++i) {
	// 		if (d > 0.0) continue;
	// 		d = mobius(p, b);
	// 		t2 += 2.0*EPS; p = ro + t2*rd;
	// 	}
	// 	// bisect towards root.
	// 	if (d > 0.0) {
	// 		for (int i = 0; i < 12; ++i) {
	// 			d = 0.5*(t1+t2); p = ro + d*rd;
	// 			if (mobius(p, b) > 0.0) t2 = d; else t1 = d;
	// 		}
	// 		col = shade(ro+d*rd, rd, b, m);
	// 	}
	// }
	
	// post-processing
	// col = smoothstep(0.0, 1.0, col);
	// col *= 0.5 + 0.5*pow(25.0*fc.x*(1.0-fc.x)*fc.y*(1.0-fc.y), 0.45);
	// col = pow(col, vec3(1.0/2.2));
	
	// fragColor = vec4(col,1.0);
}

void main() {        
  mainImage(gl_FragColor, gl_FragCoord.xy);
}