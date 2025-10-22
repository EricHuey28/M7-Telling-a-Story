shader_type canvas_item;

varying vec4 custom;

void vertex (){
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	COLOR.a *= sin(custom.z * 10.0);
}
