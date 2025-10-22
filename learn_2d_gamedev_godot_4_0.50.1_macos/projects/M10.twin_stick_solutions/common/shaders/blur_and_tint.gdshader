shader_type canvas_item;

// Blurs the background
uniform float blur_amount: hint_range(0.0, 10.0) = 0.0;
// Adds a tint. Only useful if tint_strength > 0
uniform vec4 tint : source_color;
// How much the chosen color tints the background
uniform float tint_strength : hint_range(0.0, 1.0);
// The closer to 0, the less saturated
uniform float saturation : hint_range(0.0, 1.0) = 1.0;
// Necessary in Godot 4 to obtain the screen texture
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 blurred = texture(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
	vec3 desaturated = mix(vec3(dot(blurred.rgb, vec3(0.299, 0.587, 0.114))), blurred.rgb, saturation);
	vec4 tinted = mix(vec4(desaturated.rgb, 1.0), tint, tint_strength);
	COLOR = vec4(tinted.rgb, 1.0);
}
