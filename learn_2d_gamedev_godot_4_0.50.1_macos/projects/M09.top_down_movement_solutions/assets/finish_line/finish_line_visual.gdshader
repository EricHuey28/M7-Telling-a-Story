shader_type canvas_item;

uniform sampler2D finish_line_text : repeat_enable;
uniform vec2 shape_ratio = vec2(1.0);

// This shader works by splitting the texture into rows, and masking the top and
// bottom to display text while animating a stripe pattern in the center.
void fragment() {
    // Up here we split the texture into 6 equal rows and mask the top and
    // bottom rows, in which we'll display text.
	vec2 text_uv = (vec2(1.0, 6.0) * shape_ratio);
	float total_rows = text_uv.y;

	float current_row = (UV.y * total_rows);
	float last_row_index = total_rows - 1.0;

	float top_mask = step(1.0, current_row);
	float bottom_mask = step(current_row, last_row_index);
	float text_mask = 1.0 - (top_mask * bottom_mask);

	vec2 uv = UV * shape_ratio;
	// This generates a stripe pattern that moves over time.
	float stripe_mask = step(0.0, sin(((uv.x + uv.y) - TIME * 0.1) * PI * 4.0));
	// We sample the text texture here and make it scroll left over time.
	float text_texture = texture(finish_line_text, UV * text_uv + vec2(TIME * 0.1, 0.0)).a;

	// Finally we combine the stripe pattern and text texture by combining their
	// masks.
	float mask = stripe_mask * (1.0 - text_mask);
	mask = max(0.0, mask + text_texture * text_mask);
	COLOR.a = mix(0.2, 1.0, mask);
}
