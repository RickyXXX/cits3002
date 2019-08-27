attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
//varying vec4 color;
//varying vec3 Lvec1;
//varying vec3 Lvec2;
varying vec3 pos;
varying vec3 N;

//uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
//uniform vec4 LightPosition1;
//uniform vec4 LightPosition2;
uniform float Shininess;


//part 2 added
attribute vec4 boneIDs;
attribute vec4 boneWeights;
uniform mat4 boneTransforms[64];

void main()
{
    ivec4 bone = ivec4(boneIDs);
    mat4 boneTransform =    boneWeights[0] * boneTransforms[bone[0]] +
                            boneWeights[1] * boneTransforms[bone[1]] +
                            boneWeights[2] * boneTransforms[bone[2]] +
                            boneWeights[3] * boneTransforms[bone[3]] ;


    
    vec4 vpos = boneTransform * vec4(vPosition , 1.0);
    vec4 vnorm = boneTransform * vec4(vNormal , 0.0);
    
    //vec4 vpos = vec4(vPosition , 1.0);
    // Transform vertex position into eye coordinates
    pos = (ModelView * vpos).xyz;


    // The vector to the light from the vertex    
//    Lvec1 = LightPosition1.xyz - pos;
//    Lvec2 = LightPosition2.xyz - pos;
    // Unit direction vectors for Blinn-Phong shading calculation
//    vec3 L = normalize( Lvec );   // Direction to the light source
//    vec3 E = normalize( -pos );   // Direction to the eye/camera
//    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    N = normalize( (ModelView * vnorm).xyz );

    // Compute terms in the illumination equation
//    vec3 ambient = AmbientProduct;
//
//    float Kd = max( dot(L, N), 0.0 );
//    vec3  diffuse = Kd*DiffuseProduct;
//
//    float Ks = pow( max(dot(N, H), 0.0), Shininess );
//    vec3  specular = Ks * SpecularProduct;
//
//    if (dot(L, N) < 0.0 ) {
//    specular = vec3(0.0, 0.0, 0.0);
//    }
//
//    // globalAmbient is independent of distance from the light source
//    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
//
//    //F
//    float distances = 0.2 * length(Lvec);
//    color.rgb = globalAmbient  + (ambient + diffuse + specular)*distances;
//    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
