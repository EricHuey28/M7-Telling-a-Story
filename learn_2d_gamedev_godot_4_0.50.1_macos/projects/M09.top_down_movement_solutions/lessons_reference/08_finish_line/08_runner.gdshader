shader_type canvas_item;

render_mode blend_premul_alpha;

void fragment() {
	COLOR = texture(TEXTURE, UV);
}