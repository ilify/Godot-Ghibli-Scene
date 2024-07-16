shader_type spatial;
render_mode unshaded;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_height : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D texture_normal : source_color, filter_linear_mipmap, repeat_enable;



uniform float scale;
void vertex() {
	VERTEX.y = texture(texture_height,UV).r * scale;
	NORMAL = texture(texture_normal,UV).rgb * scale;
}

void fragment() {
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo_tex.rgb;
}
