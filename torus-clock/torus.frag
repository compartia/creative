 

#ifdef GL_ES
precision highp float;
#endif

#define REFLECTIONS
#define HD
 
#define FAR 6.
#define TOR_V vec2(1.0, 0.393333)

#ifdef HD
    #define EPS 0.001
    #define STEPS 200
    #define SHAD_STEPS 20
#else
    #define STEPS 60
    #define SHAD_STEPS 2 //must be 30 or so
    #define EPS 0.005
#endif


#define TAU 6.28318530718

#define ROTATION
#define RADIUS 1.0
#define PI 3.14159265359
  
 
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


vec3 pal_c0 = vec3(0, 0, 0) / 255.;
vec3 pal_c1 = vec3(43, 10, 111) / 255.;
vec3 pal_c2 = vec3(120, 10, 142) /255.;
vec3 pal_c3 = vec3(200, 26, 44) /255.;
vec3 pal_c4 = vec3(181, 203, 134) /255.;
vec3 pal_c5 = vec3(21, 172, 215) /255.;
vec3 pal_c6 = vec3(250, 196, 176) /255.;
vec3 pal_c7 = vec3(251, 246, 218) /255.;

float relu(float x){
    return x < 0. ? 0. : x > 1. ? 1. :  x;
}

vec3 gradient(float blend){

    float blendx = 5.5 * blend;//+ 0.2 * sin(86. * fc.y) + 0.16 * sin(66. * fc.x) ;

    // blendx = 4. + 3.*sin(0.4*blendx);
    vec3 rgb = mix( pal_c0, pal_c1, relu(blendx +0.01 ));
    rgb = mix( rgb, pal_c2, relu( -1.3 + blendx  ));
    rgb = mix( rgb, pal_c3, relu( -1.3 + blendx  ));
    rgb = mix( rgb, pal_c4, relu( -2. + blendx  ));
    rgb = mix( rgb, pal_c5, relu( -3.1 + blendx  ));
    rgb = mix( rgb, pal_c6, relu( -4.1 + blendx  ));
    rgb = mix( rgb, pal_c7, relu( -5. + blendx  ));
    return rgb;
}

 
float anim_sinesine(float min, float max, float speed){
    return min + (max -min ) * 0.25 * (2.0 + sin( u_time * speed) + sin( u_time * speed * 0.31498) );
}



float opSubtraction( float d1, float d2 ) { 
    return max(-d1,d2); 
}


float opUnion( float d1, float d2 ) {  
    return min(d1,d2); 
}

float opSmoothSubtraction( float d1, float d2, float k ) {
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return mix( d2, -d1, h ) + k*h*(1.0-h); 
}

float opSmoothUnion( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h); 
}

 
float sdSphere( vec3 p, float s ){
  return length(p)-s;
}

float torus(vec3 p) {
    //  p.z *=sin(p.x*p.z + u_time);
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

float mobius(vec3 p){
    
    // cylindrical coordinates
    vec2 cyl = vec2(length(p.xy), p.z);
    float theta = atan(p.x, p.y);
    
    vec2 inCyl = vec2(1., 0) - cyl;
    // rotate 180° to form the loop
    float _rot = 0.2;
    inCyl *= rot(theta * 6. - _rot);
    // coordinates in a torus (cylindrical coordinates + position on the stripe)
    vec3 inTor = vec3(inCyl, theta * RADIUS);
    
    // add the band
    
    float bandDist = sdBox(inTor, vec3(0.17, 0.5, 100)) - 0.0001;
    float d = bandDist;

    return d;
}


float map(vec3 p){
     
    float c = 1.2;
    p.z =   mod( p.z + 0.5 * c, c) - 0.5 * c ; //translational symmetry
     

   
    float tor = torus(p);
    float mobius = mobius(p);
    float sphere = sdSphere(p, 0.23);
     
     
    float spiral =  opSmoothSubtraction( mobius, tor, 0.18  ); //opSubtraction (  tor , mob) ;

    
    return opSmoothUnion (spiral, sphere, 0.266);


    // return mobius;
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
    
    for (int i = 0; i < 50; i++){

        d = map(ro + rd*t);        
        if( abs(d) < .002 || t > FAR ) break;        
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

 

// Standard raymarching routine.
float trace(vec3 ro, vec3 rd){   
    float t = 0., d;    
    
    for (int i = 0; i < STEPS; i++){

        d = map(ro + rd*t);
        
        // Using the hacky "abs," trick, for more accuracy. 
        if(abs(d)<.0001 || t> 2.* FAR) break;                
        t += d * .175  ;  // Using more accuracy, in the first pass.
    }
    
    return t;
}

vec3 getObjectColor(vec3 p){          
    return gradient(0.5* sin(p.x*2. + 3.*p.y + 2. * u_time)+0.5); 
}

vec3  doColor(in vec3 sp, in vec3 rd, in vec3 sn, in vec3 lp, float t, in vec2 fc){

   
    vec3 ld = lp - sp; // Light direction vector.
    float lDist = max(length(ld), .001); // Light to surface distance.
    ld /= lDist; // Normalizing the light vector.
    
    // Attenuating the light, based on distance.
    float atten = 1. / (1. + lDist*.2 + lDist * lDist * .1);
    
    // Standard diffuse term.
    float diff = max(dot(sn, ld), 0.);

    vec3 fogc =  gradient( clamp(rd.z, 0.0, 1.0)+fc.x) ;
    if (t > FAR || t < 0.0){
        return fogc ;
    }

    

    // Standard specualr term.
    float spec = pow(max( dot( reflect(-ld, sn), -rd ), 0.), 8.);
    
    // Coloring the object. You could set it to a single color, to
    // make things simpler, if you wanted.

    vec3 objCol =pal_c2;
    if (t < FAR && t > 0.1){
        // return pal_c2;
        objCol = getObjectColor(sn);
    }
    // vec3 objCol = getObjectColor(sn);
    
    // Combining the above terms to produce the final scene color.
    vec3 sceneCol = (objCol*(diff + .15) + vec3(1., .6, .2)*spec*2.) * atten;
    
    
    // Fog factor -- based on the distance from the camera.
    float fogF = smoothstep(0., 0.85, t/FAR);
    //
    // Applying the background fog. Just black, in this case, but you could
    // render sky, etc, as well.
    sceneCol = mix(sceneCol, fogc, fogF); 

    
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
 
	
	#ifdef ROTATION
		mouse.x += 0.3*u_time;
	#endif
	
	mat3 m = rotY(mouse.x) * rotX(mouse.y+15.);

    
    // Ray origin. 
    vec3 ro = m * vec3(0.0, 0.0, 1.6);

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
    vec3 sceneColor = doColor(ro, rd, sn, lp, t, fc);

    float sh = 0.01;
  
    
    #ifdef REFLECTIONS
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
    #endif
    
    // Retrieving the normal at the reflected hit point.
    sn = getNormal(ro);

    // Coloring the reflected hit point, then adding a portion of it to the final scene color.
    // How much you add, and how you apply it is up to you, but I'm simply adding 35 percent.
    
    sceneColor += doColor(ro, rd, sn, lp, t, fc) * 0.35 + 0.1 * sh;
    // Other combinations... depending what you're trying to achieve.
    // sceneColor = sceneColor ;//+ doColor(ro, rd, sn, lp, t)*.5;

    // Clamping the scene color, performing some rough gamma correction (the "sqrt" bit), then 
    // presenting it to the screen.
    // sceneColor=filmicToneMapping(0.7*sceneColor);
	fragColor =  vec4(clamp(sceneColor, 0., 1.), 1.);
 
}

 
void main() {        
  mainImage(gl_FragColor, gl_FragCoord.xy);
}