shader_type canvas_item;

uniform bool invert = false;

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	if (invert==true){
		COLOR = vec4(1.0 - color.rgb, color.a);
	}
}