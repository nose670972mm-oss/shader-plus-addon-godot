shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_back;

#include "res://addons/shaders_plus/shaders_plus.gdshaderinc"

uniform vec4 shield_color : source_color = vec4(0.1, 0.6, 1.0, 1.0);
uniform float fresnel_power : hint_range(0.5, 10.0) = 3.0;

void fragment() {
    float fresnel = sp_fresnel(fresnel_power, NORMAL, VIEW);
    float pulse = sp_smooth_pulse(0.8, 1.2, 4.0, TIME);
    ALBEDO = shield_color.rgb * pulse;
    ALPHA = fresnel * shield_color.a;
}
