#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;

uniform vec3 light_ambient;
uniform int lightCount;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform float material_shininess; // n
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;

void main() {
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    vec3 position = vec3(model_matrix * vec4(vertex_position, 1));
    
    //Calculate ambient = intensity * ambient reflection coefficient
    ambient = light_ambient;
    
    //Calculate diffuse = intensity_point * diffuse reflection coefficient * (normalized surface normal * normalized light direction)
    //Calculate specular = intensity_point * specular reflection coefficient * (normalized reflected light direction * normalized view direction)^n
    vec3 normal = normalize(vertex_normal);
    for (int i = 0; i < lightCount; i++)
    {
        vec3 lightDirection = normalize(light_position[i] - position);
        diffuse = diffuse + light_color[i] * max(dot(normal, lightDirection), 0.0);
        
        vec3 reflectDirection = normalize(reflect(-lightDirection, normal)); 
        vec3 viewDirection = normalize(camera_position - position);
        specular = specular + light_color[i] * pow(max(dot(viewDirection, reflectDirection), 0.0), material_shininess);
        
    }
    //Cap colors
    ambient = clamp(ambient, 0.0, 1.0);
    diffuse = clamp(diffuse, 0.0, 1.0);
    specular = clamp(specular, 0.0, 1.0);
}

