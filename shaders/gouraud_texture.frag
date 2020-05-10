#version 300 es

precision mediump float;

in vec3 ambient;
in vec3 diffuse;
in vec3 specular;
in vec2 frag_texcoord;

uniform vec3 material_color;    // Ka and Kd
uniform vec3 material_specular; // Ks
uniform sampler2D image;        // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
    ambient = max(ambient * material_color, 0.0);
    diffuse = max(diffuse * material_color, 0.0);
    specular = max(specular * material_specular, 0.0);
    
    result = vec4((ambient + diffuse + specular), 1.0);
    
    FragColor = texture(image, frag_texcoord) * result;
}
