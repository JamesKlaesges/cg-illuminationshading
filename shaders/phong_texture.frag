#version 300 es

precision mediump float;

in vec3 frag_pos;
in vec3 frag_normal;
in vec2 frag_texcoord;

uniform vec3 light_ambient;
uniform int lightCount;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n
uniform sampler2D image;          // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
    //Calculate ambient = intensity * ambient reflection coefficient
    vec3 ambient = material_color * light_ambient;
    
    //Calculate diffuse = intensity_point * diffuse reflection coefficient * (normalized surface normal * normalized light direction)
    //Calculate specular = intensity_point * specular reflection coefficient * (normalized reflected light direction * normalized view direction)^n
    vec3 normal = normalize(frag_normal);
    vec3 diffuse = vec3(0,0,0);
    vec3 specular = vec3(0,0,0);
    for (int i = 1; i < lightCount; i++)
    {
        vec3 lightDirection = normalize(light_position[i] - frag_pos);
        diffuse = diffuse + light_color[i] * material_color * max(dot(normal, lightDirection), 0.0);
        
        vec3 reflectDirection = normalize(reflect(-lightDirection, normal)); 
        vec3 viewDirection = normalize(camera_position - frag_pos);
        specular = specular + light_color[i] * material_specular * pow(max(dot(viewDirection, reflectDirection), 0.0), material_shininess);
        
    }
    vec3 ambientCap = max(ambient, 0.0);
    vec3 diffuseCap = max(diffuse, 0.0);
    vec3 specularCap = max(specular, 0.0);
    vec3 result = (ambientCap + diffuseCap + specularCap);
    FragColor = vec4(result, 1.0) * texture(image, frag_texcoord);
}
