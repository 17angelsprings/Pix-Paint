// CANVAS .GDSHADER
// ********************************************************************************
// Script for canvas shader
// ********************************************************************************

// EXTENSTIONS
// ********************************************************************************
shader_type canvas_item;
// ********************************************************************************

// FUNCTIONS
// ********************************************************************************

// Draws alternating squares for canvas
void fragment() {
    // position of the current fragment
    vec2 uv = FRAGCOORD.xy / vec2(100);

    // indices of the square
    int xIndex = int(uv.x * 10.0); // horizontally
    int yIndex = int(uv.y * 10.0); // vertically

    // alternate between two shades
    if ((xIndex + yIndex) % 2 == 0) {
        // light gray
        COLOR = vec4(1.0, 1.0, 1.0, 1.0);
    } else {
        // dark gray
        COLOR = vec4(0.8, 0.8, 0.8, 0.8);
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
