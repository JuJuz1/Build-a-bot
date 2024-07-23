// NOTE: Shader automatically converted from Godot Engine 4.3.dev6's StandardMaterial3D.
shader_type spatial;

uniform float opacity;
uniform float r;
uniform float g;
uniform float b;
//uniform float mix_color;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on
}

void fragment() {
	// Every pixel the material is visible on
	//vec4 texture_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	//if (texture_color.a != 0.0)
		//COLOR = vec4(mix(texture_color.rbg, vec3(r,g,b), mix_color), opacity);
	//COLOR = vec4(0, 0, 0, 1);
	ALBEDO = vec3(r, g, b);
	ALPHA = opacity;
	METALLIC = 1.0;
	ROUGHNESS = 0.5;
}

void light() {
	// Every pixel for every light affecting the canvasitem
	//float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
	//LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}