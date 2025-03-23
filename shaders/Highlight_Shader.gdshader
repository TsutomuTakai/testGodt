shader_type canvas_item;


uniform vec2 highlight_tile = vec2(-1.0, -1.0); // Highlighted tile coordinates

uniform float highlight_amount = 0.5; // Amount to lighten the tile


void fragment() {

    vec2 tile_coord = floor(TEXTURE_PIXEL_SIZE * UV)/vec2(2,2); // Get tile coordinates

    if (tile_coord == highlight_tile) {

        vec4 color = texture(TEXTURE, UV);

        color.rgb = mix(color.rgb, vec3(1.0), highlight_amount); // Lighten the color

        COLOR = color;

    } else {

        COLOR = texture(TEXTURE, UV);

    }

}
