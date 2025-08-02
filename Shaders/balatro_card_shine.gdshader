shader_type canvas_item;
render_mode unshaded;

// Modified from: https://www.shadertoy.com/view/w3VGzm
float rand(float co) {
    return fract(sin(dot(vec2(co, co) ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;
    vec2 texSize = vec2(256.0, 256.0); // output resolution
    vec2 adjusted_uv = (uv - 0.5) * vec2(texSize.x / texSize.y, 1.0);

	vec2 foil = vec2(TIME + SCREEN_UV.x * 5.0, TIME * 1.2 ) ; // simulate foil movement
	vec2 rotater = vec2(cos(foil.r * 0.1221), sin(foil.r * 0.3512));
    float angle = dot(rotater, adjusted_uv) / (length(rotater) * length(adjusted_uv));

	float fac2 = max(min(
        5.0 * cos(foil.g * 0.3 + angle * 3.1415 *
        (2.2 + 0.9 * sin(foil.r * 1.65 + 0.2 * foil.g)))
        - 4.0 - max(2.0 - length(20.0 * adjusted_uv), 0.0),
        1.0), 0.0) * 0.5;

    float fac3 = 0.3 * max(min(
        2.0 * sin(foil.r * 5.0 + uv.x * 3.0 +
        3.0 * (1.0 + 0.5 * cos(foil.r * 7.0))) - 1.0, 1.0), -1.0);

    float fac4 = 0.3 * max(min(
        2.0 * sin(foil.r * 6.66 + uv.y * 3.8 +
        3.0 * (1.0 + 0.5 * cos(foil.r * 3.414))) - 1.0, 1.0), -1.0);
    float maxfac = max(max(fac2, max(fac3, fac4)) + (fac2 + fac3 + fac4), 0.0);
    vec3 foilColor = maxfac * vec3(0.2, 0.2, 0.2); // strong blue shimmer

	vec4 color = texture(TEXTURE, UV);

	COLOR = vec4(color.rgb + foilColor, color.a);
}