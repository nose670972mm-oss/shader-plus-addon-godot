// res://addons/shaders_plus/shaders_plus.gdshaderinc
// Compatibilidad total con GL Compatibility (GLES3 / WebGL) y Vulkan

#ifndef SHADERS_PLUS_INC
#define SHADERS_PLUS_INC

// --- RUIDO Y HASH (100% GLES3 Strict) ---
float sp_hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += vec2(dot(p, p + vec2(45.32, 45.32)));
	return fract(p.x * p.y);
}

float sp_value_noise(vec2 uv) {
	vec2 i = floor(uv);
	vec2 f = fract(uv);
	f = f * f * (vec2(3.0, 3.0) - vec2(2.0, 2.0) * f);
	
	float a = sp_hash21(i);
	float b = sp_hash21(i + vec2(1.0, 0.0));
	float c = sp_hash21(i + vec2(0.0, 1.0));
	float d = sp_hash21(i + vec2(1.0, 1.0));
	
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// --- TRANSFORMACIONES Y COORDENADAS UV ---
vec2 sp_rotate2d(vec2 uv, float angle) {
	uv -= vec2(0.5, 0.5);
	mat2 rot = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
	uv = rot * uv;
	return uv + vec2(0.5, 0.5);
}

vec2 sp_pixelate(vec2 uv, vec2 resolution) {
	return floor(uv * resolution) / resolution;
}

vec2 sp_scale_centered(vec2 uv, vec2 scale) {
	return (uv - vec2(0.5, 0.5)) * scale + vec2(0.5, 0.5);
}

// --- COLOR Y PROCESAMIENTO ---
vec3 sp_grayscale(vec3 rgb) {
	return vec3(dot(rgb, vec3(0.299, 0.587, 0.114)));
}

vec3 sp_posterize(vec3 color, float steps) {
	return floor(color * steps) / steps;
}

// --- ONDAS Y GEOMETRÍA ---
float sp_sine_wave(float val, float freq, float speed, float time) {
	return sin(val * freq + time * speed);
}

float sp_vignette(vec2 uv, float radius, float smoothness) {
	vec2 d = abs(uv - vec2(0.5, 0.5)) * radius;
	return smoothstep(radius, radius - smoothness, length(d));
}

// --- MODOS DE MEZCLA (BLENDING) ---
vec3 sp_blend_add(vec3 base, vec3 blend) {
	return min(base + blend, vec3(1.0, 1.0, 1.0));
}

#endif
