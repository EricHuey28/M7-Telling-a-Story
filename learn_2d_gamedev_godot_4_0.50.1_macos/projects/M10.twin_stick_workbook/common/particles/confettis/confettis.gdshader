shader_type canvas_item;

void vertex(){
	VERTEX.y *= cos(INSTANCE_CUSTOM.y * 25.0);
}
