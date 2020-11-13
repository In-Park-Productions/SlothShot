shader_type canvas_item;
render_mode unshaded;

uniform float cutt_off: hint_range(0.0,1.0);
uniform float smooth_step: hint_range(0.0,1.0);
uniform sampler2D mask : hint_albedo;
void fragment(){
	float value=texture(mask,UV).r;
	float alpha = smoothstep(cutt_off,cutt_off+smooth_step,value*(1.0 - smooth_step)+smooth_step);
	COLOR=vec4(COLOR.rgb,alpha);
}
