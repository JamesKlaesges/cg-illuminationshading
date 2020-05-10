#version 300 es

precision mediump float;

in vec3 ambient;
in vec3 diffuse;
in vec3 specular;

uniform vec3 material_color;    // Ka and Kd
uniform vec3 material_specular; // Ks

out vec4 FragColor;

void main() {
    
    vec3 ambientCap = max(ambient * material_color, 0.0);
    vec3 diffuseCap = max(diffuse * material_color, 0.0);
    vec3 specularCap = max(specular * material_specular, 0.0);
    
    vec3 result = (ambientCap + diffuseCap + specularCap);
    FragColor = vec4(result, 1.0);
}
