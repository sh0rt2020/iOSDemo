
//attribute vec4 Position; // 1
//attribute vec4 SourceColor; // 2
//
//varying vec4 DestinationColor; // 3
//
////just a constant value for all vertices
////mat4 means 4x4 matrix
//uniform mat4 Projection;
//uniform mat4 ModelView;
//
//void main(void) { // 4
//    DestinationColor = SourceColor; // 5
//    gl_Position = Projection * ModelView * Position; // 6
//}

attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 Modelview;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Projection * Modelview * Position;
    TexCoordOut = TexCoordIn; // New
}
