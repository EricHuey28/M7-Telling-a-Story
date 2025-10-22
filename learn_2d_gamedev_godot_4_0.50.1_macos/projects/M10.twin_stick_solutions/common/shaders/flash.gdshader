// This program draws an outline around sprites grouped under a CanvasGroup node.
shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 overlay_color: source_color = vec4(0, 0, 0, 1);
uniform float flash_speed = 1.0;


void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	COLOR.rgb = mix(screen_color, screen_color + overlay_color, abs(sin(TIME * flash_speed)) * 0.15).rgb;
	COLOR.a = screen_color.a;
}
