 
uniform vec2 u_resolution;
uniform float u_time;

 

// #013A5F
vec3 pal_c2 = vec3(1,58,95) / 255.;
vec3 pal_c1 = vec3(131,106,178) /255.;
vec3 pal_c3 = vec3(239,188,119) /255.;
vec3 pal_c4 = vec3(175,58,30) /255.;
vec3 pal_c5 = vec3(0,2,5) /255.;
vec3 pal_c6 = vec3(50,86,96) /255.;
vec3 pal_c7 = vec3(9,29,27) /255.;



float relu(float x){
    return x < 0. ? 0. : x > 1. ? 1. :  x;
}
 

vec3 gradient(vec3 fc){

    float blendx = 6. * fc.x + 0.1 * sin(40. * fc.y + u_time * 15.) ;

    vec3 rgb = 
          mix( pal_c1, pal_c2, relu(blendx +0.01 ));
    rgb = mix( rgb, pal_c3, relu( -1.3 + blendx  ));
    rgb = mix( rgb, pal_c4, relu( -2. + blendx  ));
    rgb = mix( rgb, pal_c5, relu( -3.1 + blendx  ));
    rgb = mix( rgb, pal_c6, relu( -4.1 + blendx  ));
    rgb = mix( rgb, pal_c7, relu( -5. + blendx  ));
    return rgb;
}

vec3 grad(float pos){

    float blendx = 6. * pos;

    vec3 rgb = 
          mix( pal_c1, pal_c2, relu(blendx +0.01 ));
    rgb = mix( rgb, pal_c3, relu( -1.3 + blendx  ));
    rgb = mix( rgb, pal_c4, relu( -2. + blendx  ));
    rgb = mix( rgb, pal_c5, relu( -3.1 + blendx  ));
    rgb = mix( rgb, pal_c6, relu( -4.1 + blendx  ));
    rgb = mix( rgb, pal_c7, relu( -5. + blendx  ));
    return rgb;
}

#define u_size 200. //; universe size
float initial_r = 1.;
#define ITERS 10
#define PI 3.14159265359
#define min_theta 2. * PI / float(ITERS)
#define EPS 0.001
#define KK (float(ITERS))
float mmod (float a, float b){
    if (a < 0.){
        return a + floor(-a / b);
    }else{
        return a - floor(a / b);
    }
        
     
}

// tonemapping from https://www.shadertoy.com/view/lslGzl
vec3 filmicToneMapping( vec3 col ) {
    col = max(vec3(0.), col - vec3(0.004));
    return (col * (6.2 * col + .5)) / (col * (6.2 * col + 1.7) + 0.06);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ){
    vec2 fc = fragCoord.xy / u_resolution.xy; 
    vec3 sceneColor = vec3(0.0, 0.0, 0.1);//gradient( vec3(fc.xy, 0)); 
	
    //universe
    vec2 u = (fc - vec2(0.5, 0.5)) * u_size;

    // float dst = length(u);
    // // u /= dst + EPS;

    // u *= initial_r + u_time;
    // // u.x = mmod( u.x , u_size );
    // // u.y = mmod( u.y , u_size );
    // dst = length(u);
    // if (dst > 40. && dst < 41.){
    //     sceneColor = pal_c4;//(1., 0.3, 0.);
    // }
    float dist = 0.;
    for (int i = 0; i < ITERS; i++){
        vec2 dir =  vec2(sin( min_theta * float(i)), cos( min_theta * float(i)) )  * (initial_r + u_time * 7.);
        // dir.x = mmod( dir.x  , u_size )- u_size*0.5;
        // dir.y = mmod( dir.y , u_size )- u_size*0.5;
        dist += cos( 0.12 * distance(dir, u));
        // if (dist < 0.5){
            sceneColor +=  grad(dist * 0.5 + 0.5 ) / (0.2 * KK * dist);
        // }
        
    }
 
    // vec3 sceneColor = gradient( vec3(fc.xy, 0)); 

    sceneColor=filmicToneMapping(sceneColor);
	fragColor =  vec4(clamp(sceneColor, 0., 1.), 1);
 
}



void main() {        
  mainImage(gl_FragColor, gl_FragCoord.xy);
}