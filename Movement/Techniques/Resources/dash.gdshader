shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur_radius : hint_range(0, 1) = 0.2; // Radius of the blur effect
uniform float blur_amount : hint_range(0, 5) = 1.0; // Strength of the blur effect
uniform float blur_inner : hint_range(0, 1) = 0.6; // Inner edge of the blur effect
uniform float blur_outer : hint_range(0, 1) = 0.66; // Outer edge of the blur effect
uniform vec4 blur_color = vec4(0.0, 0.0, 1.0, 1.0); // Blue color
uniform float line_thickness : hint_range(0, 0.05) = 0.005; // Thickness of the anime lines
uniform float line_spacing : hint_range(10, 100) = 20.0; // Spacing of the anime lines
uniform float line_boldness : hint_range(0, 5) = 1.0; // Boldness of the anime lines
uniform vec4 line_color = vec4(0.0, 0.0, 0.0, 1.0); // Black color
uniform float effect_intensity : hint_range(0, 1) = 1.0; // Intensity of the effect

void fragment() {
    // Original color of the pixel from the screen
    vec4 pixelColor = texture(screen_texture, UV);
    
    // Color with blur effect from the screen
    vec4 blurColor = textureLod(screen_texture, SCREEN_UV, blur_amount);

    // Calculate distance from the center of the screen
    vec2 uv_centered = UV - vec2(0.5, 0.5);
    float distance = length(uv_centered);

    // Apply smoothstep function to control transition between areas
    float blur = smoothstep(blur_inner - blur_radius, blur_outer, distance);

    // Mix the blur color with the blur effect
    blurColor.rgb = mix(blurColor.rgb, blur_color.rgb, blur_color.a);

    // Set the alpha component of the blur effect to the smoothstep value
    blurColor.a = blur *= effect_intensity;

    // Mix colors of the blur effect with the original pixel color based on the smoothstep value
    pixelColor.rgb = mix(pixelColor.rgb, blurColor.rgb, blur);

    // Calculate the angle for anime lines originating from the center
    float angle = atan(uv_centered.y, uv_centered.x);
    float line_pattern = abs(sin(angle * line_spacing)) * smoothstep(0.0, line_thickness, distance);

    // Enhance the line boldness
    line_pattern = pow(line_pattern, line_boldness);

    // Mask the anime lines with the blur factor
    line_pattern *= blur;

    // Apply the effect intensity
    line_pattern *= effect_intensity;

    // Blend the anime lines with the existing color
    pixelColor.rgb = mix(pixelColor.rgb, line_color.rgb, line_pattern);

    // Set the final color
    COLOR = pixelColor;
}
