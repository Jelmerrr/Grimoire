//credits: c64cosmin
 
shader_type canvas_item;
render_mode blend_mix;
 
uniform float global_rotation = 0.0;
 
mat2 getRotationMatrix(float angle){
	float r = radians(angle);
	float cs = cos(r);
	float sn = sin(r);
	return mat2(
		vec2(cs ,-sn),
		vec2(sn , cs)
	);
}
 
vec2 getPixelatedUV(vec2 inUV, vec2 texel, float angle){
	mat2 rotCW = getRotationMatrix(-angle);
	mat2 rotCCW = getRotationMatrix(angle);
	return rotCW*floor((rotCCW*inUV)/texel)*texel;
}
 
void fragment(){
	vec2 newUV = getPixelatedUV(UV, TEXTURE_PIXEL_SIZE, global_rotation);
	COLOR = texture(TEXTURE, newUV);
}