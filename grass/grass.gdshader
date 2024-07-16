shader_type spatial;
render_mode cull_disabled,unshaded;
uniform sampler2D T;
varying vec3 pos;
uniform float size;
uniform float test;
uniform vec3 wind_direction; // For displacement effect and noise scroll direction
// Length must be greater then 0, if it is the Mesh will disappear.
// Regulate the Speed and Intensity over the dedicated float variables instead.
// Use a negative y component to give it an extra touch.

uniform float wind_strength: hint_range(0.0, 1.0, 0.01) = 0.3;
uniform sampler2D wind_noise; // Periln FBM Noise looks Best
uniform float wind_noise_size: hint_range(0.0, 1.0, 0.001) = 0.05; // high values dont work well
uniform float wind_noise_speed: hint_range(0.0, 1.0, 0.001) = 0.1;
uniform sampler2D texture_height : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_normal : source_color, filter_linear_mipmap, repeat_enable;
uniform vec3 cam_pos;
uniform float grassRange = 20;
uniform float fadeGrassFactor = 0.25;
uniform vec3 scale ;

float random (vec2 uv) {
    return fract(sin(dot(uv,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
	pos = NODE_POSITION_WORLD;
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 wind_texture = texture(wind_noise, world_position.xz * wind_noise_size + normalize(-wind_direction.xz) * TIME * wind_noise_speed).rgb;
	vec3 wind_vector = (vec4(wind_texture * normalize(wind_direction) * wind_strength, 0.0) * MODEL_MATRIX).xyz;
	VERTEX += wind_vector * mix(2.0 * (pow(2.0, -UV.y)-0.5), 1.0 - UV.y, 0.5);
	vec3 Color = texture(T,pos.xz * 1.0/size-.5).rgb;
	float distancetocam = distance(pos, cam_pos);
	vec3 scaled_vertex = VERTEX * scale ;
	float rotation = random(pos.xz * 1.0/size-.5);
	mat3 rotation_matrix = mat3(
        vec3(cos(rotation), 0.0, sin(rotation)),
        vec3(0.0,1.0,0.0),
        vec3(-sin(rotation), 0.0, cos(rotation))
    );
	vec3 rotated_vertex = rotation_matrix * scaled_vertex;
	VERTEX = rotated_vertex;
	VERTEX.y += texture(texture_height,pos.xz * 1.0/size-.5).r * 6.0;

}
void fragment() {
	ALBEDO = texture(T,pos.xz * 1.0/size-.5).rgb;
	if(!FRONT_FACING){
		NORMAL = -NORMAL;
	}
}
