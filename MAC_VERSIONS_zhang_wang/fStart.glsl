//varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

//varying vec3 Lvec;
varying vec3 N;
varying vec3 pos;
uniform float texScale;
uniform sampler2D texture;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
//uniform mat4 Projection;
uniform vec4 LightPosition1;
uniform vec3 LightColor1;
uniform float LightBrightness1;

uniform vec4 LightPosition2;
uniform vec3 LightColor2;
uniform float LightBrightness2;
uniform float Shininess;

void main()
{
    vec3 Lvec1 = LightPosition1.xyz - pos;
    vec3 Lvec2 = LightPosition2.xyz - pos;
    
    vec3 L1 = normalize( Lvec1 );   // Direction to the light source
    vec3 E1 = normalize( -pos );   // Direction to the eye/camera
    vec3 H1 = normalize( L1 + E1 );  // Halfway vector
    vec3 L2 = normalize( Lvec2 );   // Direction to the light source
    vec3 E2 = normalize( -pos );   // Direction to the eye/camera
    vec3 H2= normalize( L2 + E2 );  // Halfway vector
    
    vec3 ambient1 = (LightColor1 * LightBrightness1) * AmbientProduct;
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct;
    
    float Kd1 = max( dot(L1, N), 0.0 );
    vec3  diffuse1 = Kd1*(LightColor1 * LightBrightness1)*DiffuseProduct;
    float Kd2 = max( dot(L2, N), 0.0 );
    vec3  diffuse2 = Kd2*(LightColor2 * LightBrightness2)*DiffuseProduct;
    
    //stepH, use brightness for specular highlights
    float Ks1 = pow( max(dot(N, H1), 0.0), Shininess );
    vec4  specular1 = Ks1 * vec4(SpecularProduct,1) * LightBrightness1;
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    vec4  specular2 = Ks2 * vec4(SpecularProduct,1) * LightBrightness2;
    
    if (dot(L1, N) < 0.0 ) {
        specular1 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    if (dot(L2, N) < 0.0 ) {
        specular2 = vec4(0.0, 0.0, 0.0, 1.0);
    }
    
    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    
    //F
    float distances = length(Lvec1)*0.4; //sqrt(length(Lvec1))/15.0 + 1.0 ;
    //G
    //vec4 color;
    //no mutiply the distance only division can make the light1 light
    //the distances is more larger, the light of light1  is more weak
    vec4 color = vec4((globalAmbient + (ambient1 + diffuse1)/distances + (ambient2 + diffuse2)),1.0);
    //color.a = 1.0;
    
    //stepB texture scale
    gl_FragColor = color * texture2D(texture,texCoord*texScale)+(specular1/distances) + specular2;;
}
