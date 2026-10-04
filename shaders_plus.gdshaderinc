// ============================================================================
// SHADERS PLUS - Omega Studios
// Librería de Funciones Auxiliares para Godot 4 (2D / 3D)
// ============================================================================

vec2 sp_rotate2d(vec2 uv, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(vec2(c, -s), vec2(s, c)) * (uv - 0.5) + 0.5;
}

vec2 sp_pixelate(vec2 uv, vec2 resolution) {
    return floor(uv * resolution) / resolution;
}
