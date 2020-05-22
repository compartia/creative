 
uniform vec2 u_resolution;
 uniform float u_time;

vec3 filmicToneMapping( vec3 col ) {
    col = max(vec3(0.), col - vec3(0.004));
    return (col * (6.2 * col + .5)) / (col * (6.2 * col + 1.7) + 0.06);
}

#013A5F
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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 fc = fragCoord.xy / u_resolution.xy; 
    // vec2 prop = fragColor.xy/u_resolution.xy;
    float blendx = 5. * fc.x + 0.08 * sin(186. * fc.y) + 0.16 * sin(66. * fc.x) ;
    vec3 rgb = 
          mix( pal_c1, pal_c2, relu(blendx +0.01 ));
    rgb = mix( rgb, pal_c3, relu( -1.3 + blendx  ));
    rgb = mix( rgb, pal_c4, relu( -2. + blendx  ));
    rgb = mix( rgb, pal_c5, relu( -3.1 + blendx  ));
    rgb = mix( rgb, pal_c6, relu( -4.1 + blendx  ));
    rgb = mix( rgb, pal_c7, relu( -5. + blendx  ));
    // rgb = mix( rgb, pal_c3, relu(-0.9 + fc.x * 5.));
    // rgb = mix( rgb, pal_c3, 0.8+fc.x );
    // rgb = mix( rgb, pal_c3, fc.x * 1.);
    
    


    // float r  = 0.5 + 0.44 *  sin(fc.x * 22.);
    // float g  = 0.2 + 0.33 *  sin(fc.x * 37.);
    // float b  = 0.2 + 0.5  *  cos(fc.x * 57.);
	// vec2 uv = -1.0 + 2.0 * fc;
	// uv.x *= u_resolution.x/u_resolution.y;	


    vec3 sceneColor = rgb;// vec3(r, g, b);

    // sceneColor = filmicToneMapping(0.6 * sceneColor);

	fragColor =  vec4(clamp(sceneColor, 0., 1.), 1);
 
}



void main() {        
  mainImage(gl_FragColor, gl_FragCoord.xy);
}