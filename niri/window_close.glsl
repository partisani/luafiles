vec4 fall_and_rotate(vec3 coords_geo, vec3 size_geo) {
    // For this shader, set animation curve to linear for best results.

    // Simulate an accelerated fall: square the (linear) progress.
    float progress = niri_clamped_progress * niri_clamped_progress;

    // Get our rotation pivot point coordinates at the bottom center of the window.
    vec2 coords = (coords_geo.xy - vec2(0.5, 1.0)) * size_geo.xy;

    // Move the window down to simulate a fall.
    coords.y -= progress * 200.0;

    // Randomize rotation direction and maximum angle.
    float random = (niri_random_seed - 0.5) / 2.0;
    random = sign(random) - random;
    float max_angle = 0.05 * random;

    // Rotate the window around our pivot point.
    float angle = progress * max_angle;
    mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    coords = rotate * coords;

    // Transform the coordinates back.
    coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 1.0), 1.0);

    // Sample the window texture.
    vec3 coords_tex = niri_geo_to_tex * coords_geo;
    vec4 color = texture2D(niri_tex, coords_tex.st);

    // Multiply by alpha to fade out.
    return color * (1.0 - niri_clamped_progress);
}

vec4 close_color(vec3 coords_geo, vec3 size_geo) {
    return fall_and_rotate(coords_geo, size_geo);
}
