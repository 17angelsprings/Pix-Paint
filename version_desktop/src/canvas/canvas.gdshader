// CANVAS .GDSHADER
// ********************************************************************************
// Script for canvas shader
// ********************************************************************************

// ASSOCIATED SCENES
// ********************************************************************************
// canvas.tcsn
// ********************************************************************************

// EXTENSTIONS
// ********************************************************************************
shader_type canvas_item;
// ********************************************************************************

// FUNCTIONS
// ********************************************************************************

// Draws alternating squares for canvas
// @params: none
// @return: none
void fragment() {
    // Position of the current fragment
    vec2 uv = FRAGCOORD.xy / vec2(100);

    // Indices of the square
    int xIndex = int(uv.x * 10.0); // Horizontally
    int yIndex = int(uv.y * 10.0); // vertically

    // Alternate between two shades
    if ((xIndex + yIndex) % 2 == 0) {
        COLOR = vec4(1.0, 1.0, 1.0, 1.0);	// Light gray
    } else {
        COLOR = vec4(0.9, 0.9, 0.9, 0.9);	// Dark gray
    }
}
