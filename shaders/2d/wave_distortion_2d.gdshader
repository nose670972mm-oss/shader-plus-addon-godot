shader_type canvas_item;

#include "res://addons/shaders_plus/shaders_plus.gdshaderinc"

uniform float wave_speed : hint_range(0.1, 10.0) = 2.0;
uniform float wave_freq : hint_range(1.0, 50.0) = 10.0;
uniform float wave_amp : hint_range(0.0, 0.1) = 0.02;

void fragment() {
    vec2 uv = UV;
    float wave = sp_sine_wave(uv.y, wave_freq, wave_speed, TIME) * wave_amp;
    uv.x += wave;
    COLOR = texture(TEXTURE, uv);
}
