shader_type canvas_item;

// Dot grid parameters
uniform float dot_spacing_px = 0.1; // space between dots, in pixels
uniform float dot_radius_px = 0.4;   // dot radius, in pixelsts)
uniform vec4 bg_color = vec4(0.3, 0.3, 0.3, 1.0); // dot color
uniform vec4 dot_color  = vec4(0.7, 0.7, 0.7, 1.0); // background color

void fragment() {
 	vec2 spacing_uv = TEXTURE_PIXEL_SIZE * dot_spacing_px;
    float radius_uv = (TEXTURE_PIXEL_SIZE.x) * dot_radius_px;

    // Find position within cell
    vec2 cell_uv = mod(UV, spacing_uv) / spacing_uv;
    vec2 centered = cell_uv - 0.5;
    float dist = length(centered);

    float dot = smoothstep(radius_uv, radius_uv * 0.8, dist);
    dot = 1.0 - dot;

    COLOR = mix(bg_color, dot_color, dot) * 0.8;
}