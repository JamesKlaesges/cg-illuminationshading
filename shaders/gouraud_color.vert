#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
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
    vec3 FragPos = vec3(model_matrix * vec4(vertex_position, 1.0));
    
    //Calculate ambient = intensity * ambient reflection coefficient
    ambient = light_color * light_ambient;
    
    //Calculate diffuse = intensity_point * diffuse reflection coefficient * (normalized surface normal * normalized light direction)
    vec3 normal = normalize(vertex_normal);
    vec3 lightDirection = normalize(light_position - FragPos);
    diffuse = light_color * max(dot(normal, lightDir), 0.0);
    
    //Calculate specular = intensity_point * specular reflection coefficient * (normalized reflected light direction * normalized view direction)^n
    vec3 reflectDirection = reflect(-lightDirection, normal);  
    vec3 viewDirection = normalize(camera_position - FragPos);
    specular = light_color * pow(max(dot(viewDirection, reflectDirection), 0.0), material_shininess);
}
